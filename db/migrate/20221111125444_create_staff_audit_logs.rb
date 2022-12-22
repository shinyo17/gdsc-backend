class CreateStaffAuditLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_audit_logs do |t|
      t.references :auditable, polymorphic: true, null: false
      t.references :staff_user, null: false, foreign_key: true
      t.string :action
      t.datetime :acted_at

      t.timestamps
    end
  end
end
