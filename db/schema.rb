# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151017184838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "ad_applications", force: :cascade do |t|
    t.text     "note"
    t.string   "state"
    t.integer  "ad_id"
    t.integer  "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ad_applications", ["ad_id"], name: "index_ad_applications_on_ad_id", using: :btree
  add_index "ad_applications", ["entity_id"], name: "index_ad_applications_on_entity_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "start_time"
    t.string   "location"
    t.datetime "end_time"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "entity_id"
  end

  add_index "ads", ["entity_id"], name: "index_ads_on_entity_id", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "key_hint"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "application_joiners", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "relation"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "application_id"
  end

  add_index "application_joiners", ["application_id"], name: "index_application_joiners_on_application_id", using: :btree
  add_index "application_joiners", ["entity_id"], name: "index_application_joiners_on_entity_id", using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "band_id"
    t.integer  "party_id"
    t.date     "start_time"
    t.date     "end_time"
  end

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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.text     "description"
    t.text     "social_media"
    t.hstore   "data"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "user_id"
  end

  add_index "entities", ["data"], name: "index_entities_on_data", using: :gin
  add_index "entities", ["user_id"], name: "index_entities_on_user_id", using: :btree

  create_table "event_joiners", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  add_index "event_joiners", ["entity_id"], name: "index_event_joiners_on_entity_id", using: :btree
  add_index "event_joiners", ["event_id"], name: "index_event_joiners_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "recurrence_pattern"
    t.datetime "recurrence_ends_at"
    t.string   "state"
    t.integer  "price"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title"
    t.text     "description"
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "band_id"
    t.integer  "party_id"
  end

  create_table "message_participants", force: :cascade do |t|
    t.integer  "message_thread_id"
    t.integer  "entity_id"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "message_participants", ["entity_id"], name: "index_message_participants_on_entity_id", using: :btree
  add_index "message_participants", ["message_thread_id"], name: "index_message_participants_on_message_thread_id", using: :btree

  create_table "message_threads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "message_thread_id"
    t.datetime "deleted_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "messages", ["message_thread_id"], name: "index_messages_on_message_thread_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "review_joiners", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "state"
  end

  add_index "review_joiners", ["entity_id"], name: "index_review_joiners_on_entity_id", using: :btree
  add_index "review_joiners", ["review_id"], name: "index_review_joiners_on_review_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.text     "description"
    t.integer  "rating"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "registration_token"
    t.text     "user_data"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "ad_applications", "ads"
  add_foreign_key "ad_applications", "entities"
  add_foreign_key "ads", "entities"
  add_foreign_key "api_keys", "users"
  add_foreign_key "application_joiners", "applications"
  add_foreign_key "application_joiners", "entities"
  add_foreign_key "entities", "users"
  add_foreign_key "event_joiners", "entities"
  add_foreign_key "event_joiners", "events"
  add_foreign_key "message_participants", "entities"
  add_foreign_key "message_participants", "message_threads"
  add_foreign_key "messages", "message_threads"
  add_foreign_key "review_joiners", "entities"
  add_foreign_key "review_joiners", "reviews"
end
