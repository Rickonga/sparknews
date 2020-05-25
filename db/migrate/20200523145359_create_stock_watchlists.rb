class CreateStockWatchlists < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_watchlists do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :watchlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
