class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    resolution = 1
    start_time = 1572651390
    end_time = 1572910590
    sql_query = "name ILIKE :query OR ticker ILIKE :query"
    stock = params[:query].nil? ? Stock.find_by(ticker: "AAPL") : Stock.find_by(sql_query, query: "#{params[:query]}%")
    ticker = stock.nil? ? "AAPL" : stock["ticker"].upcase

    @quotes = policy_scope(use_stock_api(ticker, stock, resolution, start_time, end_time))
  end

  def show
    authorize @stocks
  end

  private

  def use_stock_api(ticker, stock, resolution, start_time, end_time)
    # stock.quotes.destroy_all
    if stock.quotes.exists?
      if stock.quotes.last.time_stamp < Time.at(end_time)
        start = stock.quotes.last.time_stamp.to_i + 1
        url = "https://finnhub.io/api/v1/stock/candle?symbol=#{ticker}&resolution=#{resolution}&from=#{start}&to=#{end_time}&token=br2kq1frh5rbm8ou44kg"
        quotes = JSON.parse(open(url).read)
        if quotes["c"].nil?
          stock.quotes.where("time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time))
        else
          quotes["c"].each_with_index do |c, index|
            stock.quotes.create!(time_stamp: Time.at(quotes["t"][index]),
                                open: quotes["o"][index],
                                close: quotes["c"][index],
                                low: quotes["l"][index],
                                high: quotes["h"][index],
                                volume: quotes["v"][index])
          end
          stock.quotes.where("time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time))
          #Stock.includes(:quotes).where(quotes: {"time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time)})
        end
      else
        stock.quotes.where("time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time))
      end
    else
      url = "https://finnhub.io/api/v1/stock/candle?symbol=#{ticker}&resolution=#{resolution}&from=#{start_time}&to=#{end_time}&token=br2kq1frh5rbm8ou44kg"
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
      #Stock.includes(:quotes).where(quotes: {"time_stamp BETWEEN ? AND ?", Time.at(start_time), Time.at(end_time)})
    end
  end
end
