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

ActiveRecord::Schema.define(version: 20200409142812) do

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true, using: :btree
  end

  create_table "mylist_vtubers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "mylist_id"
    t.integer  "vtuber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mylist_id"], name: "index_mylist_vtubers_on_mylist_id", using: :btree
    t.index ["vtuber_id"], name: "index_mylist_vtubers_on_vtuber_id", using: :btree
  end

  create_table "mylists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                     null: false
    t.text     "cover",      limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_mylists_on_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_mylists_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                                null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "videos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "videoId",            null: false
    t.string   "name"
    t.datetime "publishedAt"
    t.datetime "scheduledStartTime"
    t.datetime "actualStartTime"
    t.datetime "actualEndTime"
    t.integer  "vtuber_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["vtuber_id"], name: "index_videos_on_vtuber_id", using: :btree
  end

  create_table "vtubers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                       null: false
    t.string   "twitter",                    null: false
    t.integer  "company_id"
    t.string   "channel",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "icon",         limit: 65535
    t.text     "banner",       limit: 65535
    t.string   "channelTitle"
    t.index ["channel"], name: "index_vtubers_on_channel", unique: true, using: :btree
    t.index ["company_id"], name: "index_vtubers_on_company_id", using: :btree
    t.index ["name"], name: "index_vtubers_on_name", unique: true, using: :btree
    t.index ["twitter"], name: "index_vtubers_on_twitter", unique: true, using: :btree
  end

  add_foreign_key "mylist_vtubers", "mylists"
  add_foreign_key "mylist_vtubers", "vtubers"
  add_foreign_key "mylists", "users"
  add_foreign_key "videos", "vtubers"
  add_foreign_key "vtubers", "companies"
end
