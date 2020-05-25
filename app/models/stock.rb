class Stock < ApplicationRecord
  has_many :quotes, dependent: :destroy
  has_many :strategies
  has_many :futures, through: :strategies
  has_many :tweets, through: :stock_tweets
  has_many :watchlists, through: :stock_watchlists
  validates :ticker, uniqueness: true, presence: true
  validates :name, presence: true
end
