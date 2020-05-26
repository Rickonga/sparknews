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

ActiveRecord::Schema.define(version: 2020_05_26_094921) do


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
    t.string "resolution"
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

  create_table "stock_watchlists", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "watchlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_stock_watchlists_on_stock_id"
    t.index ["watchlist_id"], name: "index_stock_watchlists_on_watchlist_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "ticker"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country"
    t.string "currency"
    t.string "exchange"
    t.string "industry"
    t.string "ipo"
    t.string "logo"
    t.integer "marketCapitalization"
    t.integer "shareOutstanding"
    t.string "company_name"
    t.string "weburl"
    t.string "phone"
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
    t.datetime "publish"
    t.string "avatar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "follower"
  end

  create_table "user_watchlist_stocks", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "user_watchlist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_user_watchlist_stocks_on_stock_id"
    t.index ["user_watchlist_id"], name: "index_user_watchlist_stocks_on_user_watchlist_id"
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

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  create_table "watchlists", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  add_foreign_key "quotes", "stocks"
  add_foreign_key "saved_tweets", "tweets"
  add_foreign_key "saved_tweets", "users"
  add_foreign_key "stock_tweets", "stocks"
  add_foreign_key "stock_tweets", "tweets"
  add_foreign_key "stock_watchlists", "stocks"
  add_foreign_key "stock_watchlists", "watchlists"
  add_foreign_key "strategies", "futures"
  add_foreign_key "strategies", "stocks"
  add_foreign_key "user_watchlist_stocks", "stocks"
  add_foreign_key "user_watchlist_stocks", "user_watchlists"
  add_foreign_key "user_watchlists", "users"
  add_foreign_key "user_watchlists", "watchlists"
end
