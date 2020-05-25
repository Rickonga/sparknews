class Tweet < ApplicationRecord
  has_many :stocks, through: :stock_tweets
  has_many :tweets, through: :saved_tweets
end
