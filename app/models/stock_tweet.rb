class StockTweet < ApplicationRecord
  belongs_to :stock
  belongs_to :tweet
end
