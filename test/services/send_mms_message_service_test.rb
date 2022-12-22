
require 'test_helper'

class SendMmsMessageServiceTest < ActiveSupport::TestCase
  test "send_mms_message's first test" do
    message = { to: '01064184332', text: '테스트' }
    puts SendMmsMessageService.call(message)
    assert true
  end
end