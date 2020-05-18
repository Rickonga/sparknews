class Stock < ApplicationRecord
  has_many :quotes
  has_many :watchlists
  has_many :strategies
  has_many :stock_tweets
  has_many :tweets, through :stock_tweets
end
