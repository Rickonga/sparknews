class CreateStrategies < ActiveRecord::Migration[6.0]
  def change
    create_table :strategies do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :future, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
