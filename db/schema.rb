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

ActiveRecord::Schema[7.2].define(version: 2026_02_08_130203) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clicks", force: :cascade do |t|
    t.bigint "short_url_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_url_id"], name: "index_clicks_on_short_url_id"
  end

  create_table "short_urls", force: :cascade do |t|
    t.string "original_url", null: false
    t.string "code", null: false
    t.integer "clicks_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_short_urls_on_code", unique: true
    t.index ["original_url"], name: "index_short_urls_on_original_url"
  end

  add_foreign_key "clicks", "short_urls"
end
