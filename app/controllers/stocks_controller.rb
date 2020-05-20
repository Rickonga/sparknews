class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @stocks = policy_scope(Stock)
  end

  def show
    authorize @stocks
  end
end
