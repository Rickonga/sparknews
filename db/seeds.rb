# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
url = "https://finnhub.io/api/v1/stock/symbol?exchange=US"
stocks = JSON.parse(open(url).read)
stocks.each do |e|
  Stock.create!(name: e["description"], ticker: e["symbol"]) unless e["description"].empty? || e["symbol"].empty?
end

puts "finished Stocks"
