class UserWatchlistStocksController < ApplicationController
  def create
    @user_watchlist_stock = UserWatchlistStock.new
    stock = Stock.find(params[:stock_id])
    user_watchlist = UserWatchlist.find(params[:user_watchlist_stock][:user_watchlist])
    @user_watchlist_stock.stock = stock
    @user_watchlist_stock.user_watchlist = user_watchlist
    authorize @user_watchlist_stock
    @user_watchlist_stock.save
    redirect_to stocks_path
  end
end
