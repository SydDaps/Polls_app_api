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

ActiveRecord::Schema.define(version: 2022_04_14_013119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "section_id"
    t.string "description"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "super_option_id"
    t.index ["section_id"], name: "index_options_on_section_id"
    t.index ["super_option_id"], name: "index_options_on_super_option_id"
  end

  create_table "organizers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "polls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.uuid "organizer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "publish_status"
    t.index ["organizer_id"], name: "index_polls_on_organizer_id"
  end

  create_table "sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poll_id"], name: "index_sections_on_poll_id"
  end

  create_table "voters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_id", null: false
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "index_number"
    t.boolean "voted"
    t.string "pass_key"
    t.string "phone_number"
    t.index ["poll_id"], name: "index_voters_on_poll_id"
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_id"
    t.uuid "option_id"
    t.uuid "section_id"
    t.uuid "voter_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["option_id"], name: "index_votes_on_option_id"
    t.index ["poll_id"], name: "index_votes_on_poll_id"
    t.index ["section_id"], name: "index_votes_on_section_id"
    t.index ["voter_id"], name: "index_votes_on_voter_id"
  end

  add_foreign_key "options", "options", column: "super_option_id"
  add_foreign_key "options", "sections"
  add_foreign_key "polls", "organizers"
  add_foreign_key "sections", "polls"
  add_foreign_key "voters", "polls"
  add_foreign_key "votes", "options"
  add_foreign_key "votes", "polls"
  add_foreign_key "votes", "sections"
  add_foreign_key "votes", "voters"
end
