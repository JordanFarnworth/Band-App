how# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150801223642) do

  create_table "ad_applications", force: :cascade do |t|
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "band_id"
    t.integer  "ad_id"
  end

  add_index "ad_applications", ["ad_id"], name: "index_ad_applications_on_ad_id"
  add_index "ad_applications", ["band_id"], name: "index_ad_applications_on_band_id"

  create_table "ads", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "genre"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "entity_id"
  end

  add_index "ads", ["entity_id"], name: "index_ads_on_entity_id"

  create_table "bands", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "social_media"
    t.string   "email"
    t.integer  "phone_number"
    t.string   "mailing_address"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "bands", ["deleted_at"], name: "index_bands_on_deleted_at"

  create_table "contacts", force: :cascade do |t|
    t.date     "from_date"
    t.date     "until_date"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "band_id"
    t.integer  "entity_id"
  end

  add_index "contacts", ["band_id"], name: "index_contacts_on_band_id"
  add_index "contacts", ["entity_id"], name: "index_contacts_on_entity_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "entities", force: :cascade do |t|
    t.string   "title"
    t.string   "owner"
    t.string   "address"
    t.text     "description"
    t.text     "social_media"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "entities", ["deleted_at"], name: "index_entities_on_deleted_at"

  create_table "events", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "recurrence_pattern"
    t.datetime "recurrence_ends_at"
    t.string   "state"
    t.float    "price"
    t.string   "price_options"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "entity_id"
    t.integer  "band_id"
  end

  add_index "events", ["band_id"], name: "index_events_on_band_id"
  add_index "events", ["deleted_at"], name: "index_events_on_deleted_at"
  add_index "events", ["entity_id"], name: "index_events_on_entity_id"

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "entity_id"
    t.integer  "band_id"
  end

  add_index "favorites", ["band_id"], name: "index_favorites_on_band_id"
  add_index "favorites", ["entity_id"], name: "index_favorites_on_entity_id"

  create_table "message_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "message_id"
    t.integer  "entity_id"
  end

  add_index "message_participants", ["entity_id"], name: "index_message_participants_on_entity_id"
  add_index "message_participants", ["message_id"], name: "index_message_participants_on_message_id"

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.text     "description"
    t.integer  "rating"
    t.integer  "entity_id"
    t.integer  "band_id"
  end

  add_index "reviews", ["band_id"], name: "index_reviews_on_band_id"
  add_index "reviews", ["entity_id"], name: "index_reviews_on_entity_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["username"], name: "index_users_on_username"

end
