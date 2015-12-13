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

ActiveRecord::Schema.define(version: 20151116151338) do

  create_table "articles", force: :cascade do |t|
    t.integer  "club_id"
    t.string   "title"
    t.string   "abstract"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "articles", ["title"], name: "index_articles_on_title", unique: true

  create_table "articles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "article_id"
  end

  add_index "articles_users", ["user_id", "article_id"], name: "index_articles_users_on_user_id_and_article_id", unique: true

  create_table "clubs", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "introduction"
    t.string   "head_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "log_num"
    t.string   "club_account"
  end

  add_index "clubs", ["club_account"], name: "index_clubs_on_club_account", unique: true

  create_table "clubs_users", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["user_id", "article_id"], name: "index_notes_on_user_id_and_article_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "stu_num"
    t.string   "name"
    t.string   "password"
    t.string   "phone_num",  limit: 11
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "log_num"
    t.string   "user_head"
    t.string   "email"
  end

  add_index "users", ["stu_num"], name: "index_users_on_stu_num", unique: true

end
