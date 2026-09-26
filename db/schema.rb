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

ActiveRecord::Schema[8.1].define(version: 2026_09_26_034956) do
  create_table "champions", force: :cascade do |t|
    t.date "day", null: false
    t.string "champion_name"
    t.integer "champion_points"
    t.string "best_predictor_name"
    t.integer "best_predictor_correct"
    t.string "fastest_mate_winner"
    t.integer "fastest_mate_moves"
    t.integer "longest_game_moves"
    t.integer "games_count", default: 0, null: false
    t.integer "players_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day"], name: "index_champions_on_day", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.date "day", null: false
    t.integer "room_id"
    t.string "room_name", null: false
    t.string "theme_key", default: "classic", null: false
    t.integer "white_player_id"
    t.integer "black_player_id"
    t.string "result", null: false
    t.integer "moves_count", default: 0, null: false
    t.boolean "counted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["black_player_id"], name: "index_games_on_black_player_id"
    t.index ["day", "counted"], name: "index_games_on_day_and_counted"
    t.index ["white_player_id"], name: "index_games_on_white_player_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "room_id", null: false
    t.string "nickname", null: false
    t.string "body", limit: 300, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
  end

  create_table "players", force: :cascade do |t|
    t.date "day", null: false
    t.string "token", null: false
    t.string "name", null: false
    t.integer "points", default: 0, null: false
    t.integer "wins", default: 0, null: false
    t.integer "draws", default: 0, null: false
    t.integer "losses", default: 0, null: false
    t.integer "streak", default: 0, null: false
    t.integer "predictions_correct", default: 0, null: false
    t.integer "predictions_total", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "day, lower(name)", name: "index_players_on_day_and_lower_name", unique: true
    t.index ["day", "points"], name: "index_players_on_day_and_points"
    t.index ["day", "token"], name: "index_players_on_day_and_token", unique: true
  end

  create_table "predictions", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "player_id", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_predictions_on_player_id"
    t.index ["room_id", "player_id"], name: "index_predictions_on_room_id_and_player_id", unique: true
    t.index ["room_id"], name: "index_predictions_on_room_id"
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
    t.string "theme_key", default: "classic", null: false
    t.integer "time_control", default: 600, null: false
    t.integer "white_ms"
    t.integer "black_ms"
    t.datetime "turn_started_at"
    t.index ["creator_token"], name: "index_rooms_on_creator_token"
    t.index ["last_activity_at"], name: "index_rooms_on_last_activity_at"
    t.index ["slug"], name: "index_rooms_on_slug", unique: true
    t.index ["status"], name: "index_rooms_on_status"
  end

  add_foreign_key "games", "players", column: "black_player_id"
  add_foreign_key "games", "players", column: "white_player_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "predictions", "players"
  add_foreign_key "predictions", "rooms"
end
