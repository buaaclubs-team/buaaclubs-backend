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

ActiveRecord::Schema.define(version: 20151217092208) do

  create_table "applications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "club_id",    limit: 4
    t.string   "reason",     limit: 255
    t.integer  "accept",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "club_id",    limit: 4
    t.string   "title",      limit: 255
    t.string   "abstract",   limit: 255
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "type",       limit: 4
    t.date     "deadline"
  end

  add_index "articles", ["title"], name: "index_articles_on_title", unique: true, using: :btree

  create_table "articles_users", id: false, force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "article_id", limit: 4
  end

  add_index "articles_users", ["user_id", "article_id"], name: "index_articles_users_on_user_id_and_article_id", unique: true, using: :btree

  create_table "clubs", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "password",     limit: 255
    t.string   "introduction", limit: 255
    t.string   "head_url",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "log_num",      limit: 4
    t.string   "club_account", limit: 255
    t.string   "pics",         limit: 255
  end

  add_index "clubs", ["club_account"], name: "index_clubs_on_club_account", unique: true, using: :btree

  create_table "clubs_users", id: false, force: :cascade do |t|
    t.integer "club_id", limit: 4
    t.integer "user_id", limit: 4
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "article_id",  limit: 4
    t.integer  "reply_id",    limit: 4
    t.string   "content",     limit: 255
    t.integer  "sender_id",   limit: 4
    t.integer  "sender_type", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "informs", force: :cascade do |t|
    t.integer  "club_id",    limit: 4
    t.string   "users",      limit: 255
    t.string   "content",    limit: 255
    t.integer  "type",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "club_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "notes", ["user_id", "article_id"], name: "index_notes_on_user_id_and_article_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "stu_num",           limit: 255
    t.string   "name",              limit: 255
    t.string   "password",          limit: 255
    t.string   "phone_num",         limit: 11
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "log_num",           limit: 4
    t.string   "user_head",         limit: 255
    t.string   "email",             limit: 255
    t.integer  "phone_verify",      limit: 4
    t.integer  "email_verify",      limit: 4
    t.integer  "email_verify_code", limit: 4
    t.integer  "phone_verify_code", limit: 4
  end

  add_index "users", ["stu_num"], name: "index_users_on_stu_num", unique: true, using: :btree

  create_table "webmails", force: :cascade do |t|
    t.integer  "sender_id",     limit: 4
    t.string   "sender_name",   limit: 255
    t.integer  "receiver_id",   limit: 4
    t.integer  "receiver_type", limit: 4
    t.string   "content",       limit: 255
    t.integer  "ifread",        limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
