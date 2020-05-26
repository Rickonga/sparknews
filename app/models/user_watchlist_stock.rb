class UserWatchlistStock < ApplicationRecord
  belongs_to :stock
  belongs_to :user_watchlist
end
