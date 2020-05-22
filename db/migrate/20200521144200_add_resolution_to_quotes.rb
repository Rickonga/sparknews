class AddResolutionToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :resolution, :string
  end
end
