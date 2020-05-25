class RemoveStockIdFromWatchlists < ActiveRecord::Migration[6.0]
  def change
    remove_reference :watchlists, :stock, null: false, foreign_key: true
  end
end
