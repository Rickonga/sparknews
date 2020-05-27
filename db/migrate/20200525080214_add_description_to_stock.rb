class AddDescriptionToStock < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :country, :string
    add_column :stocks, :currency, :string
    add_column :stocks, :exchange, :string
    add_column :stocks, :industry, :string
    add_column :stocks, :ipo, :string
    add_column :stocks, :logo, :string
    add_column :stocks, :marketCapitalization, :integer
    add_column :stocks, :shareOutstanding, :integer
    add_column :stocks, :company_name, :string
    add_column :stocks, :weburl, :string
    add_column :stocks, :phone, :string
    remove_column :stocks, :description, :string
  end
end
