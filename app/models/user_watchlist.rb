class UserWatchlist < ApplicationRecord
  belongs_to :user
  belongs_to :watchlist
end
