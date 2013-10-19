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

ActiveRecord::Schema.define(version: 20131019103510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sites", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.string   "verification_token"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", force: true do |t|
    t.integer  "tippable_id"
    t.string   "tippable_type"
    t.string   "title"
    t.text     "content"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tips", ["tippable_id", "tippable_type"], name: "index_tips_on_tippable_id_and_tippable_type", using: :btree

  create_table "tutorials", force: true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tutorials", ["site_id"], name: "index_tutorials_on_site_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
