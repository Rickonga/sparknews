class CreateUserWatchlists < ActiveRecord::Migration[6.0]
  def change
    create_table :user_watchlists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :watchlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
