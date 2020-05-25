class StockWatchlistsController < ApplicationController
  def create
    @stock = Stock.find(params[:stock_id])
    authorize @stock
    @watchlist = Watchlist.find(params[:stock_watchlist][:watchlist])
    @stockwatchlist = StockWatchlist.create(stock: @stock, watchlist: @watchlist)
    redirect_to stocks_path
  end
end
