class Stock < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_many :watchlists
  has_many :strategies
  has_many :stock_tweets
  has_many :tweets, through: :stock_tweets

  validates :ticker, uniqueness: true, presence: true
  validates :name, presence: true
end
