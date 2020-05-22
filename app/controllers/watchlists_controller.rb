class WatchlistsController < ApplicationController

  skip_before_action :authenticate_user!, only: %i[new create]


  def new
    authorize @watchlist
    @watchlist = Watchlist.new
  end

  def create
    authorize @watchlist
    @watchlist = Watchlist.new(watchlist_params)
    @watchlist.user = current_user

    if @watchlist.save
      redirect_to stocks_path(@stock)
    else
      render :new
    end
  end

  private

  def stock_params
    params.require(:watchlist).permit(stock_id)
  end

end
