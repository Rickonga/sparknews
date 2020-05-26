class CreateUserWatchlistStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_watchlist_stocks do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :user_watchlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
