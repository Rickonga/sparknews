class Tweet < ApplicationRecord
  has_many :stock_tweets
  has_many :saved_tweets
end
