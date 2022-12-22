class Staff::StaffController < ActionController::Base
  layout "staff"
  before_action :header_staff_comments

  def index
  end

  def header_staff_comments
    @staff_user = StaffUser.find(5)
    @comments = @staff_user.fetch_unchecked_comments
    @comment = StaffComment.new
  end
end
