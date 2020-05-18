class CreateStockTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_tweets do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
