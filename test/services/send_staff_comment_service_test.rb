
require 'test_helper'

class SendStaffCommentServiceTest < ActiveSupport::TestCase
  test "send_staff_comment's first test" do
    staff = StaffUser.create!(name: 'alfonso')
    user = User.create(name: 'alfonso_user')
    path = '/staff/users'
    body = '이상한 사용자임'
    params = { staff_user_id: staff.id, record: user, path: path, body: body }
    pp SendStaffCommentService.call(params)
    assert true
  end
end