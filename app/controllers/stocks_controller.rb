class StocksController < ApplicationController

  def index
    create_stocks_with_api
    @stocks = policy_scope(Stock)
  end

  def show
    authorize @stock
  end

  private

  def create_stocks_with_api
    url = "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=br2g2ufrh5rbm8ou31m0"
    stocks = JSON.parse(open(url).read)
    stocks.each do |e|
      Stock.create!(name: e["description"], ticker: e["symbol"]) unless e["description"].empty? || e["symbol"].empty?
    end
  end
end
