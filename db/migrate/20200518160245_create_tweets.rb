class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.text :content
      t.string :author
      t.date :publish
      t.string :url

      t.timestamps
    end
  end
end
