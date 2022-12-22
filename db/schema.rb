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

ActiveRecord::Schema[7.0].define(version: 2022_11_11_125444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "staff_audit_logs", force: :cascade do |t|
    t.string "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.bigint "staff_user_id", null: false
    t.string "action"
    t.datetime "acted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_staff_audit_logs_on_auditable"
    t.index ["staff_user_id"], name: "index_staff_audit_logs_on_staff_user_id"
  end

  create_table "staff_comments", force: :cascade do |t|
    t.bigint "staff_user_id", null: false
    t.string "staff_name", default: "", null: false
    t.tsvector "staff_name_tsvector"
    t.string "body", default: "", null: false
    t.tsvector "body_tsvector"
    t.string "path"
    t.string "target_model_name"
    t.jsonb "read_users", default: []
    t.jsonb "checked_users", default: []
    t.bigint "target_model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, (path)::text)", name: "index_staff_comments_on_to_tsvector_english_path", using: :gin
    t.index ["body_tsvector"], name: "index_staff_comments_on_body_tsvector", using: :gin
    t.index ["staff_name_tsvector"], name: "index_staff_comments_on_staff_name_tsvector", using: :gin
    t.index ["staff_user_id"], name: "index_staff_comments_on_staff_user_id"
  end

  create_table "staff_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.tsvector "email_tsvector"
    t.string "password_digest", default: "", null: false
    t.string "name", default: "", null: false
    t.tsvector "name_tsvector"
    t.string "username"
    t.tsvector "username_tsvector"
    t.string "phone", default: "", null: false
    t.tsvector "phone_tsvector"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, (email)::text)", name: "index_staff_users_on_to_tsvector_english_email", using: :gin
    t.index ["name_tsvector"], name: "index_staff_users_on_name_tsvector", using: :gin
    t.index ["username_tsvector"], name: "index_staff_users_on_username_tsvector", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.tsvector "email_tsvector"
    t.string "password_digest", default: "", null: false
    t.string "name", default: "", null: false
    t.tsvector "name_tsvector"
    t.string "username"
    t.tsvector "username_tsvector"
    t.string "phone", default: "", null: false
    t.tsvector "phone_tsvector"
    t.string "bank_name", default: "", null: false
    t.string "bank_account", default: "", null: false
    t.string "fcm_token", default: "", null: false
    t.datetime "marketing_targeted_at"
    t.datetime "marketing_rejected_at"
    t.datetime "last_sign_in_app_at"
    t.string "last_sign_in_app_version"
    t.string "last_sign_in_app_platform"
    t.datetime "deleted_at"
    t.string "zipcode"
    t.string "address1"
    t.string "address2"
    t.string "display_address"
    t.tsvector "display_address_tsvector"
    t.date "birthday"
    t.string "gender"
    t.string "inbound_route"
    t.jsonb "phone_verified_log", default: []
    t.datetime "phone_verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, (email)::text)", name: "index_users_on_to_tsvector_english_email", using: :gin
    t.index ["display_address_tsvector"], name: "index_users_on_display_address_tsvector", using: :gin
    t.index ["name_tsvector"], name: "index_users_on_name_tsvector", using: :gin
    t.index ["username_tsvector"], name: "index_users_on_username_tsvector", using: :gin
  end

  add_foreign_key "staff_audit_logs", "staff_users"
  add_foreign_key "staff_comments", "staff_users"
end
