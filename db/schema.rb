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

ActiveRecord::Schema.define(version: 2015_10_16_065816) do

  create_table "chapters", force: :cascade do |t|
    t.integer "number"
    t.integer "season_id"
    t.string "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_chapters_on_season_id"
  end

  create_table "qualities", force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qualities_shows", id: false, force: :cascade do |t|
    t.integer "show_id"
    t.integer "quality_id"
    t.index ["quality_id"], name: "index_qualities_shows_on_quality_id"
    t.index ["show_id"], name: "index_qualities_shows_on_show_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "number"
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_seasons_on_show_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
