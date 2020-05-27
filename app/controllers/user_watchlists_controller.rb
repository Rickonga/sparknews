class UserWatchlistsController < ApplicationController
  def destroy
    user_watchlist = UserWatchlist.find(params[:id])
    authorize user_watchlist
    user_watchlist.destroy
    redirect_to stocks_path(query: params[:query])
  end
end
