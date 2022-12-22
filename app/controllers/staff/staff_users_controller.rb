class Staff::StaffUsersController < Staff::StaffController
  def index
    staff_users = StaffUser.staff_search(params[:query])
    @staff_users = staff_users.page(params[:page]).per(100)
  end
end
