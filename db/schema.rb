# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_18_160905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "futures", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.integer "value"
    t.datetime "time_stamp"
    t.integer "dynamic"
    t.integer "open"
    t.integer "close"
    t.integer "high"
    t.integer "low"
    t.integer "volume"
    t.integer "change"
    t.integer "change_percent"
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_quotes_on_stock_id"
  end

  create_table "saved_tweets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tweet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_saved_tweets_on_tweet_id"
    t.index ["user_id"], name: "index_saved_tweets_on_user_id"
  end

  create_table "stock_tweets", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "tweet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_stock_tweets_on_stock_id"
    t.index ["tweet_id"], name: "index_stock_tweets_on_tweet_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "ticker"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "strategies", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "future_id", null: false
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["future_id"], name: "index_strategies_on_future_id"
    t.index ["stock_id"], name: "index_strategies_on_stock_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.text "content"
    t.string "author"
    t.date "publish"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_watchlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "watchlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_watchlists_on_user_id"
    t.index ["watchlist_id"], name: "index_user_watchlists_on_watchlist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_watchlists_on_stock_id"
  end

  add_foreign_key "quotes", "stocks"
  add_foreign_key "saved_tweets", "tweets"
  add_foreign_key "saved_tweets", "users"
  add_foreign_key "stock_tweets", "stocks"
  add_foreign_key "stock_tweets", "tweets"
  add_foreign_key "strategies", "futures"
  add_foreign_key "strategies", "stocks"
  add_foreign_key "user_watchlists", "users"
  add_foreign_key "user_watchlists", "watchlists"
  add_foreign_key "watchlists", "stocks"
end
