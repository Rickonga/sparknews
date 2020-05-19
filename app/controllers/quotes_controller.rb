require "open-uri"
require "json"

class QuotesController < ApplicationController
  def index
    api_key = "Tpk_000e351e505e48da928ed22d7bb0423e"
    ticker = params[:query]
    @stock = use_stock_api(ticker, api_key)
  end

  private

  def use_stock_api(ticker, api_key)
    if Stock.exists?(ticker: ticker.upcase)
      if Stock.find_by(ticker: ticker.upcase).quotes.last.time_stamp.strftime("%m/%d/%Y") == (DateTime.now - 1).strftime("%m/%d/%Y")
        return Stock.find_by(ticker: ticker.upcase)
      else
        update_data_from_stock_api(ticker, api_key)
      end
    else
      get_data_from_stock_api(ticker, api_key)
    end
  end

  def get_data_from_stock_api(ticker, api_key)
    url = "https://sandbox.iexapis.com/stable/stock/#{ticker}/batch?types=quote,chart&range=5y&token=#{api_key}"
    stocks = JSON.parse(open(url).read)
    stock = Stock.create!(ticker: stocks["quote"]["symbol"], name: stocks["quote"]["companyName"])
    stocks["chart"].each do |e|
      stock.quotes.create(time_stamp: e["date"],
                          close: e["close"],
                          open: e["open"],
                          high: e["high"],
                          low: e["low"],
                          volume: e["volume"],
                          change: e["change"],
                          change_percent: e["changePercent"])
    end
    return stock
  end

  def update_data_from_stock_api(ticker, api_key)
    stock = Stock.find_by(ticker: ticker.upcase)
    url = "https://sandbox.iexapis.com/stable/stock/#{ticker}/batch?types=quote,chart&range=5y&token=#{api_key}"
    stocks = JSON.parse(open(url).read)
    stocks["chart"].where("time_stamp > ?", stock.quotes.last.time_stamp).each do |e|
      stock.quotes.create(time_stamp: e["date"],
                          close: e["close"],
                          open: e["open"],
                          high: e["high"],
                          low: e["low"],
                          volume: e["volume"],
                          change: e["change"],
                          change_percent: e["changePercent"])
    end
    return stock
  end
end
