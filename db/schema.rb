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

ActiveRecord::Schema.define(version: 20160211102336) do

  create_table "invoices", force: :cascade do |t|
    t.integer  "partner_id"
    t.integer  "document_type", limit: 1,  default: 0
    t.string   "number",        limit: 32,                 null: false
    t.text     "items",                                    null: false
    t.decimal  "total"
    t.boolean  "paid",                     default: false
    t.date     "deal_date",                                null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "invoices", ["partner_id"], name: "index_invoices_on_partner_id"

  create_table "partners", force: :cascade do |t|
    t.string  "first_name",   limit: 32
    t.string  "last_name",    limit: 32
    t.string  "country",      limit: 32
    t.string  "city",         limit: 32
    t.integer "postcode"
    t.string  "address",      limit: 64
    t.string  "phone_number", limit: 16
    t.string  "company_name", limit: 32
    t.integer "eik"
    t.string  "vat_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "username", limit: 32
    t.string  "password"
    t.boolean "active",              default: false
    t.integer "level",    limit: 2,  default: 0
    t.string  "last_ip",  limit: 15
  end

end
