# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150815155819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.string   "industry"
    t.string   "symbol"
    t.string   "yahoo_symbol"
    t.string   "series"
    t.string   "isin_code"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "status",       default: 0, null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.integer  "company_id"
    t.date     "quote_date"
    t.float    "open_price"
    t.float    "close_price"
    t.float    "low_price"
    t.float    "high_price"
    t.float    "volume"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0, null: false
    t.integer  "quote_type",      default: 0, null: false
    t.datetime "quote_timestamp"
    t.string   "company_symbol"
    t.float    "average_price"
  end

  add_index "quotes", ["company_id"], name: "index_quotes_on_company_id", using: :btree

  create_table "trades", force: :cascade do |t|
    t.string   "company_symbol"
    t.integer  "trade_type",             null: false
    t.integer  "reference"
    t.integer  "trade_transaction_type"
    t.decimal  "amount"
    t.datetime "time_of_trade"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "unit"
  end

end
