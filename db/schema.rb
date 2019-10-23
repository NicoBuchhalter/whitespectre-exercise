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

ActiveRecord::Schema.define(version: 2019_10_23_110358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_events", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "name"
    t.text "description"
    t.boolean "published", default: false
    t.string "location"
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_group_events_on_creator_id"
    t.index ["discarded_at"], name: "index_group_events_on_discarded_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "group_events", "users", column: "creator_id"
end
