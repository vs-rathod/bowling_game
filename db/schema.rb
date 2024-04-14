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

ActiveRecord::Schema[7.1].define(version: 2024_04_13_154803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "frames", force: :cascade do |t|
    t.integer "frame_number"
    t.integer "status", default: 0
    t.integer "pins_knocked_down_by_first_throw"
    t.integer "pins_knocked_down_by_second_throw"
    t.boolean "strike", default: false
    t.boolean "spare", default: false
    t.integer "bonus_throw_pins"
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_frames_on_game_id"
    t.index ["player_id"], name: "index_frames_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "no_of_players"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "frames", "games"
  add_foreign_key "frames", "players"
end
