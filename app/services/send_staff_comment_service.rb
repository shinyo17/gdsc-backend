class SendStaffCommentService
  attr_reader :params, :staff_user
  def initialize(params)
    @params = params
    @staff_user = found_staff_user
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    result
  end

  private

  def result
    created_comment
  end

  def found_staff_user
    StaffUser.find(params[:staff_user_id])
  end

  def created_comment
    staff_user.staff_comments.create(built_attributes)
  end

  def built_attributes
    attributes = { staff_name: staff_user.name }
    attributes[:body] = params[:body]
    attributes[:path] = params[:path]
    attributes[:read_users] = [built_staff_attributes]
    attributes[:checked_users] = [built_staff_attributes]
    if params[:record].present?
      record = params[:record]
      target_model_name = record.class.to_s
      target_model_id = record.id
      attributes[:target_model_name] = target_model_name
      attributes[:target_model_id] = target_model_id
    end
    attributes
  end

  def built_staff_attributes
    {
      staff_user_id: staff_user.id,
      staff_name: staff_user.name,
      created_at: Time.current
    }
  end
end