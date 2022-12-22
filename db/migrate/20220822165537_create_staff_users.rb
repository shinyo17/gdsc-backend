class CreateStaffUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_users do |t|
      t.string "email", default: "", null: false
      t.tsvector :email_tsvector
      t.string "password_digest", default: "", null: false
      t.string "name", default: "", null: false
      t.tsvector :name_tsvector
      t.string "username"
      t.tsvector :username_tsvector
      t.string "phone", default: "", null: false
      t.tsvector :phone_tsvector
      t.timestamps

      t.index :name_tsvector, using: "GIN"
      t.index :username_tsvector, using: "GIN"

      t.index "to_tsvector('english', email)", using: "GIN"
    end
  end
end
