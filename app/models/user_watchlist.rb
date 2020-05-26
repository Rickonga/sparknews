class UserWatchlist < ApplicationRecord
  belongs_to :user
  belongs_to :watchlist
  has_many :user_watchlist_stocks
end
