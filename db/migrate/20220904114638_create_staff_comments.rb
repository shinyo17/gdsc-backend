class CreateStaffComments < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_comments do |t|
      t.references :staff_user, null: false, foreign_key: true
      t.string :staff_name, default: "", null: false
      t.tsvector :staff_name_tsvector
      t.string :body, default: "", null: false
      t.tsvector :body_tsvector
      t.string :path
      t.string :target_model_name
      t.jsonb :read_users, default: []
      t.jsonb :checked_users, default: []
      t.bigint :target_model_id

      t.timestamps

      t.index :staff_name_tsvector, using: "GIN"
      t.index :body_tsvector, using: "GIN"

      t.index "to_tsvector('english', path)", using: "GIN"
    end
  end
end
