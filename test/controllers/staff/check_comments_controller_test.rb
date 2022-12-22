require "test_helper"

class Staff::CheckCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get staff_check_comments_create_url
    assert_response :success
  end
end
