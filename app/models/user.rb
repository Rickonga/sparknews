class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tweets, through: :saved_tweets
  has_many :saved_tweets
  has_many :watchlists, through: :user_watchlists
  has_many :user_watchlists
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
