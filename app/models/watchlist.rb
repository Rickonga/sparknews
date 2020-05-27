class Watchlist < ApplicationRecord
  has_many :stocks, through: :stock_watchlists
  has_many :users, through: :user_watchlists
  has_many :user_watchlists
end
