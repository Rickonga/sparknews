require "open-uri"
require "json"

class QuotesController < ApplicationController

  def index
    #resolution can be [1, 5, 15, 30, 60, D, W, M]
    #start_time/end_time need to be an integer
    resolution = 1
    start_time = 1572651390
    end_time = 1572910590
    sql_query = "name ILIKE :query OR ticker ILIKE :query"
    stock = params[:query].nil? ? Stock.find_by(ticker: "AAPL") : Stock.find_by(sql_query, query: "#{params[:query]}%")

    ticker = (stock["ticker"] || "aapl").upcase
    @quotes = policy_scope(use_stock_api(ticker, stock, resolution, start_time, end_time))
  end

  private

  def use_stock_api(ticker, stock, resolution, start_time, end_time)
    stock.quotes.destroy_all
    url = "https://finnhub.io/api/v1/stock/candle?symbol=#{ticker}&resolution=#{resolution}&from=#{start_time}&to=#{end_time}"
    quotes = JSON.parse(open(url).read)
    quotes["c"].each_with_index do |c, index|
      stock.quotes.create!(time_stamp: Time.at(quotes["t"][index]),
                          open: quotes["o"][index],
                          close: quotes["c"][index],
                          low: quotes["l"][index],
                          high: quotes["h"][index],
                          volume: quotes["v"][index])
    end
    stock.quotes.where("time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time))
  end
end
