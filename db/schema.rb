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

ActiveRecord::Schema.define(version: 2020_10_18_061712) do

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "event_time"
    t.string "venu"
    t.string "organizer"
    t.integer "entry_fee"
    t.integer "participants"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "newsfeeds", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "content"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_newsfeeds_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.boolean "is_admin", default: false
    t.string "email"
    t.string "contact"
    t.string "designation"
    t.string "club"
    t.string "address"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "event_id"
    t.index ["event_id"], name: "index_users_on_event_id"
  end

  add_foreign_key "newsfeeds", "users"
  add_foreign_key "users", "events"
end
