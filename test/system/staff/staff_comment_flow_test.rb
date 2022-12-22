require 'application_system_test_case'

class Staff::StaffCommentFlowTest < ApplicationSystemTestCase
  # TODO : 리다이렉션이 되는지를 테스트하는 것에서, TurboStream 기반으로 올바르게 렌더링이 되는지 테스트하는 방향으로 바뀌어야 합니다.
  def setup
    @user = FactoryBot.create(:staff_user, id: 5)
  end

  test '인수인계 노트 리스트 화면에서 댓글을 달 경우, 인수인계 노트 리스트화면으로 리다이렉트 된다.' do
    url = staff_staff_comments_path
    visit url

    assert_selector "#staff-comments-toggle-button"

    toggle_button = first("#staff-comments-toggle-button")
    toggle_button.click

    textarea = first("div[data-controller=staff-comments] textarea#staff_comment_body")
    textarea.fill_in with: "hello world"

    submit_button = first('div[data-controller=staff-comments] button[type=submit]')
    submit_button.click

    sleep(1)
    assert_current_path url

    staff_comment_component = first(".staff-comment")
    assert_includes staff_comment_component.text, "hello world"
  end

  test '인수인계 노트 상세화면에서 댓글을 달 경우, 인수인계 노트 상세화면으로 리다이렉트 된다.' do
    comment = FactoryBot.create(:staff_comment, staff_user: @user)
    url = edit_staff_staff_comment_path(comment)
    visit url

    assert_selector "#staff-comments-toggle-button"

    toggle_button = first("#staff-comments-toggle-button")
    toggle_button.click

    textarea = first("div[data-controller=staff-comments] textarea#staff_comment_body")
    textarea.fill_in with: "hello world"

    submit_button = first('div[data-controller=staff-comments] button[type=submit]')
    submit_button.click

    sleep(1)
    assert_current_path url

    staff_comment_component = first(".staff-comment")
    assert_includes staff_comment_component.text, "hello world"
    # assert_includes staff_comment_component.text, url
  end
end
