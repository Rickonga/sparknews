require 'open-uri'

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    end_time = Time.now.to_i
    resolution = nil || "15"
    sql_query = "name ILIKE :query OR ticker ILIKE :query"

    @stock = params[:query].nil? ? Stock.find_by(ticker: "AAPL") : Stock.find_by(sql_query, query: "#{params[:query]}%")
    # @stock.description = use_company_profile_api(stock) if stock.description.nil?
    create_all_Data(@stock, end_time)
    @quotes = policy_scope(@stock.quotes.where(resolution: resolution.to_s ))

    client = set_twitter
    @posts = []
    @posts = client.search("#{@stock.ticker} -rt", lang: "en").first(50)
    @watchlist = Watchlist.new
    @user_watchlists = current_user.watchlists
    @stockwatchlist = StockWatchlist.new
  end

  def create_stock_watchlist

  end

  private

  def set_twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_SECRET"]
    end
    client
  end


  def create_all_Data(stock, end_time)
    if stock.quotes.exists?
      check_when_it_was_updated(stock, end_time)
    else
      time_span_in_days_back = [5 * 30 * 12, 12 * 30, 6 * 30, 14, 7, 4, 1]
      ["M", "W", "D", 60, 30, 15, 1].each_with_index do |resolution, index|
        start_date = (Time.at(end_time).to_date - time_span_in_days_back[index]).to_time.to_i
        quotes = use_stock_api(stock, resolution, start_date, end_time)
        create_stock_quotes(stock, quotes,resolution, end_time)
      end
    end
  end

  def use_company_profile_api(stock)
    url = "https://finnhub.io/api/v1/stock/profile2?symbol=#{stock.ticker}&token=#{ENV["FINNHUB_API_KEY"]}"
    description = JSON.parse(open(url).read)
  end

  def use_stock_api(stock, resolution, start_time, end_time)
    url = "https://finnhub.io/api/v1/stock/candle?symbol=#{stock.ticker}&resolution=#{resolution}&from=#{start_time}&to=#{end_time}&token=#{ENV["FINNHUB_API_KEY"]}"
    quotes = JSON.parse(open(url).read)
  end

  def create_stock_quotes(stock, quotes,resolution, end_time)
    quotes["c"].each_with_index do |c, index|
      stock_quote = stock.quotes.new(time_stamp: Time.at(quotes["t"][index]),
                          open: (quotes["o"][index] * 100),
                          close: (quotes["c"][index] * 100),
                          low: (quotes["l"][index] * 100),
                          high: (quotes["h"][index] * 100),
                          volume: quotes["v"][index],
                          resolution: resolution.to_s)
      stock_quote.save if stock_quote.valid?
    end
  end

  def check_when_it_was_updated(stock, end_time)
    time_span_when_need_update_in_min = [60 * 24 * 31, 60 * 24 * 8, 60 * 25, 70, 35, 20, 5]
    ["M", "W", "D", 60, 30, 15, 1].each_with_index do |resolution, index|
      last_updated = stock.quotes.where(resolution: resolution.to_s).order("time_stamp DESC").limit(1).first.time_stamp
      total_difference_in_min = (Time.at(end_time.to_i) - last_updated) / 60
      if total_difference_in_min > time_span_when_need_update_in_min[index]
        quotes = use_stock_api(stock,resolution,last_updated.to_i,end_time)
        break if quotes["c"].nil?
        create_stock_quotes(stock, quotes,resolution, end_time)
      end
    end
  end
end

