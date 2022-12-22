
require 'test_helper'

class PhoneAuthServiceTest < ActiveSupport::TestCase
  test "30초도 안되어서 다시 인증하는 것 방지" do
    user = User.create(email: 'onesup.lee@gmail.com', phone: '01064184332')

    params = { phone: '01064184332' }
    PhoneAuthService.call(params)
    travel 25.second do
      assert_raises PhoneAuthService::TooOftenVerifying do
        PhoneAuthService.call(params)
      end
    end
  end

  test "맞는 인증번호 던졌을때 인증 통과, 틀리면 인증 실패" do
    user = User.create(email: 'onesup.lee@gmail.com', phone: '010')
    params = { phone: '010' }
    code = PhoneAuthService.call(params)[:code]

    params = { phone: '010', code: code }
    assert PhoneAuthService.call(params)

    params = { phone: '010', code: "wrong#{code}" }
    assert PhoneAuthService.call(params) == false
  end

  test "여러번 인증 요청 후 마지막 인증코드로 인증 통과" do
    user = User.create(email: 'onesup.lee@gmail.com', phone: '010')

    params = { phone: '010' }
    PhoneAuthService.call(params)

    travel 31.second do
      code = PhoneAuthService.call(params)[:code]
      params = { phone: '010', code: code }
      assert PhoneAuthService.call(params)
      params = { phone: '010', code: "wrong#{code}" }
      assert PhoneAuthService.call(params) == false
    end
  end
end