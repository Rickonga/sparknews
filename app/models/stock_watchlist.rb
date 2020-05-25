class StockWatchlist < ApplicationRecord
  belongs_to :stock
  belongs_to :watchlist
end
