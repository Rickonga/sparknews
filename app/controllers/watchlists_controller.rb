class WatchlistsController < ApplicationController

  skip_before_action :authenticate_user!, only: %i[new create]


  def new
    authorize @watchlist
    @watchlist = Watchlist.new
  end

  def create
    @watchlist = Watchlist.create(watchlist_params)
    @user_watchlist = UserWatchlist.new(watchlist: @watchlist, user: current_user)
    authorize @watchlist

    if @user_watchlist.save
      redirect_to stocks_path
    else
      redirect_to stocks_path
    end
  end

  private

  def watchlist_params
    params.require(:watchlist).permit(:name)
  end

end
