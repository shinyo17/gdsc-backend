require "test_helper"

class Staff::ReadCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get staff_read_comments_create_url
    assert_response :success
  end
end
