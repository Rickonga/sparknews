require 'open-uri'

class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    end_time = Time.now.to_i
    resolution = params[:resolution] || "W"
    sql_query = "name ILIKE :query OR ticker ILIKE :query"
    @stock = params[:query].nil? ? Stock.find_by(ticker: "AAPL") : Stock.find_by(sql_query, query: "#{params[:query]}%")
    if @stock.nil?
      policy_scope(Stock.all)
      render 'pages/stock_not_found'
    else
      use_company_profile_api(@stock) if @stock.company_name.nil?
      create_stock_quote_data(@stock, resolution, end_time)
      last_quote_time_stamp = @stock.quotes.where(resolution: resolution).order("time_stamp DESC").limit(1).first.time_stamp.to_date
      resolution_hash = {"M" => 5 * 30 * 12 - 1, "W" => 12 * 30 - 1, "D" => 6 * 30 - 1, "60" => 13, "30" => 6, "15" => 3, "1" => 0}
      a = (last_quote_time_stamp - resolution_hash[resolution])
      @quotes = policy_scope(@stock.quotes.where("resolution = ? AND time_stamp > ?", resolution, a))
      client = set_twitter
      @posts = []
      @posts = client.search("#{@stock.ticker} -rt", lang: "en").first(50)
      @watchlist = Watchlist.new
      @user_watchlists = current_user&.watchlists
      @stockwatchlist = StockWatchlist.new
    end
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

  def use_company_profile_api(stock)
    url = "https://finnhub.io/api/v1/stock/profile2?symbol=#{stock.ticker}&token=#{ENV["FINNHUB_API_KEY"]}"
    description = JSON.parse(open(url).read)
    stock.update(company_name: description["name"],
                 country: description["country"],
                 industry: description["finnhubIndustry"],
                 marketCapitalization: description["marketCapitalization"],
                 shareOutstanding: description["shareOutstanding"],
                 phone: description["phone"],
                 logo: description["logo"],
                 weburl: description["weburl"],
                 exchange: description["exchange"],
                 ipo: description["ipo"])
  end

  #Stock API
  def create_stock_quote_data(stock, resolution, end_time)
    if stock.quotes.exists?
      return create_time_span(stock, resolution, end_time) if stock.quotes.where(resolution: resolution).empty?
      check_when_it_was_updated(stock, resolution, end_time)
    else
      create_time_span(stock, resolution, end_time)
    end
  end

  def create_time_span(stock, resolution, end_time)
    resolution_hash = {"M" => 5 * 30 * 12, "W" => 12 * 30, "D" => 6 * 30, "60" => 14, "30" => 7, "15" => 4, "1" => 1}
    start_date = (Time.at(end_time).to_date - resolution_hash[resolution]).to_time.to_i
    quotes = use_stock_api(stock, resolution, start_date, end_time)
    create_stock_quotes(stock, quotes, resolution)
  end

  def use_stock_api(stock, resolution, start_time, end_time)
    url = "https://finnhub.io/api/v1/stock/candle?symbol=#{stock.ticker}&resolution=#{resolution}&from=#{start_time}&to=#{end_time}&token=#{ENV["FINNHUB_API_KEY"]}"
    quotes = JSON.parse(open(url).read)
    if quotes["s"] == "no_data"
      start_date = set_earlier_start_date(end_time)
      url = "https://finnhub.io/api/v1/stock/candle?symbol=#{stock.ticker}&resolution=#{resolution}&from=#{start_date}&to=#{end_time}&token=#{ENV["FINNHUB_API_KEY"]}"
      return quotes = JSON.parse(open(url).read)
    else
      return quotes
    end
  end

  def create_stock_quotes(stock, quotes,resolution)
    quotes["c"].each_with_index do |c, index|
      stock_quote = stock.quotes.new(time_stamp: Time.at(quotes["t"][index]),
                          open: (quotes["o"][index] * 100),
                          close: (quotes["c"][index] * 100),
                          low: (quotes["l"][index] * 100),
                          high: (quotes["h"][index] * 100),
                          volume: quotes["v"][index],
                          resolution: resolution)
      stock_quote.save if stock_quote.valid?
    end
  end

  def check_when_it_was_updated(stock,resolution, end_time)
    resolution_update_time_hash = {"M" => 60 * 24 * 31, "W" => 60 * 24 * 8, "D" => 60 * 25, "60" => 70, "30" => 35, "15" => 20, "1" => 5}
    last_updated = stock.quotes.where(resolution: resolution).order("time_stamp DESC").limit(1).first.time_stamp
    total_difference_in_min = (Time.at(end_time.to_i) - last_updated) / 60
    if total_difference_in_min > resolution_update_time_hash[resolution]
      quotes = use_stock_api(stock,resolution,last_updated.to_i,end_time)
      return nil if quotes["c"].nil?
      create_stock_quotes(stock, quotes,resolution)
    end
  end

  def set_earlier_start_date(end_time)
    start_date = prior_friday(Time.at(end_time))
    start_date.to_time.to_i
  end

  def prior_friday(date)
    days_before = (date.wday + 1) % 7 + 1
    date.to_date - days_before
  end
end

