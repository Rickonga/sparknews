class ChangeTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :follower, :integer
    rename_column :tweets, :url, :avatar
    change_column :tweets, :publish, :datetime
  end
end
