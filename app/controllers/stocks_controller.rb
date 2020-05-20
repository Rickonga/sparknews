class StocksController < ApplicationController

  def index
    @stocks = policy_scope(Stock)
  end

  def show
    authorize @stock
  end
end
