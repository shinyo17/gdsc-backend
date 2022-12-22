require "test_helper"

class StaffUserTest < ActiveSupport::TestCase
  test "체크한 것으로 처리된 인수인계 노트는 fetch 하지 않는다." do 
    nico = FactoryBot.create(:staff_user)
    alfonso = FactoryBot.create(:staff_user)
    tyga = FactoryBot.create(:staff_user)

    staff_comments = FactoryBot.create_list(:staff_comment, 10, staff_user: alfonso)

    limit = 6
    context = {limit: limit}

    assert_equal nico.fetch_unchecked_comments(**context).count, limit
    assert_equal tyga.fetch_unchecked_comments(**context).count, limit

    nico_checked_comments = nico.fetch_unchecked_comments(**context)
    nico_checked_comments.each do |comment|
      nico.check_staff_comment(comment)
    end

    assert_equal nico.fetch_unchecked_comments(**context).count, 10 - limit
    assert_equal tyga.fetch_unchecked_comments(**context).count, limit
  end
end
