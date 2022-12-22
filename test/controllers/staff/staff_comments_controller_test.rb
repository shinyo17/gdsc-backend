require "test_helper"

class Staff::StaffCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get staff_staff_comments_create_url
    assert_response :success
  end

  test "should get index" do
    get staff_staff_comments_index_url
    assert_response :success
  end

  test "should get show" do
    get staff_staff_comments_show_url
    assert_response :success
  end

  test "should get update" do
    get staff_staff_comments_update_url
    assert_response :success
  end

  test "should get delete" do
    get staff_staff_comments_delete_url
    assert_response :success
  end
end
