class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes do |t|
      t.integer :value
      t.datetime :time_stamp
      t.integer :dynamic
      t.integer :open
      t.integer :close
      t.integer :high
      t.integer :low
      t.integer :volume
      t.integer :change
      t.integer :change_percent
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
