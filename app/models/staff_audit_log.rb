class StaffAuditLog < ApplicationRecord
  belongs_to :auditable, polymorphic: true
  belongs_to :staff_user
end
