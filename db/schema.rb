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

ActiveRecord::Schema.define(version: 2018_09_07_081507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_attendees_on_event_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "chatroom_messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chatroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "image"
    t.string "body"
    t.index ["chatroom_id"], name: "index_chatroom_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_messages_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "group_id"
    t.string "chatroom_name"
    t.string "chatroom_image"
    t.integer "chatroom_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_chatrooms_on_group_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "group_id"
    t.string "title"
    t.string "details"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "image"
    t.index ["group_id"], name: "index_events_on_group_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "group_code"
    t.string "group_name"
    t.string "group_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prayer_comments", force: :cascade do |t|
    t.bigint "prayer_id"
    t.bigint "user_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prayer_id"], name: "index_prayer_comments_on_prayer_id"
    t.index ["user_id"], name: "index_prayer_comments_on_user_id"
  end

  create_table "prayers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "subject"
    t.string "details"
    t.string "answered_details"
    t.integer "is_answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "share_to"
    t.boolean "is_hidden"
    t.integer "group_id"
    t.index ["group_id"], name: "index_group_id"
    t.index ["user_id"], name: "index_prayers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "phone_number"
    t.string "birth_date"
    t.string "gender"
    t.string "username"
    t.string "role"
    t.json "avatar"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "state"
    t.string "zip"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
