# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_26_025855) do
  create_table "messages", force: :cascade do |t|
    t.integer "room_id", null: false
    t.string "nickname", null: false
    t.string "body", limit: 300, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "status", default: "waiting", null: false
    t.string "creator_token", null: false
    t.string "white_token"
    t.string "black_token"
    t.string "white_name"
    t.string "black_name"
    t.text "moves", default: "[]", null: false
    t.string "result"
    t.datetime "last_activity_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_token"], name: "index_rooms_on_creator_token"
    t.index ["last_activity_at"], name: "index_rooms_on_last_activity_at"
    t.index ["slug"], name: "index_rooms_on_slug", unique: true
    t.index ["status"], name: "index_rooms_on_status"
  end

  add_foreign_key "messages", "rooms"
end
