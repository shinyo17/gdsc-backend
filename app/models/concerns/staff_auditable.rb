module StaffAuditable
  extend ActiveSupport::Concern

  included do
    has_many :staff_audit_logs, as: :auditable
  end
end
