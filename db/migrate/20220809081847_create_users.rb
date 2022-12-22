class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string "email", default: "", null: false
      t.tsvector :email_tsvector
      t.string "password_digest", default: "", null: false
      t.string "name", default: "", null: false
      t.tsvector :name_tsvector
      t.string "username"
      t.tsvector :username_tsvector
      t.string "phone", default: "", null: false
      t.tsvector :phone_tsvector
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
      t.tsvector :display_address_tsvector
      t.date "birthday"
      t.string "gender"
      t.string "inbound_route"
      t.jsonb "phone_verified_log", default: []
      t.datetime "phone_verified_at"
      t.timestamps

      t.index :name_tsvector, using: "GIN"
      t.index :username_tsvector, using: "GIN"
      t.index :display_address_tsvector, using: "GIN"

      t.index "to_tsvector('english', email)", using: "GIN"
    end
  end
end
