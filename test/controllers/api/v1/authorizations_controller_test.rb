require "test_helper"

class Api::V1::AuthorizationsControllerTest < ActionDispatch::IntegrationTest

  test "없는 사용자를 찾을 때" do
    User.create(phone: '111', email: 'alk@alkonso', name: '강원섭')
    User.create(phone: '010', email: 'alf@alfonso', name: '이원섭')
    put api_v1_authorizations_url( { auth: { phone: '01' } } )
    assert_response :unauthorized
  end

  test "로그인 인증발송" do
    User.create(phone: '111', email: 'alk@alkonso', name: '강원섭')
    User.create(phone: '01064184332', email: 'alf@alfonso', name: '이원섭')
    put api_v1_authorizations_url( { auth: { phone: '01064184332' } } )
    name = response.parsed_body["name"]
    assert_response :success
    assert (name == '이원섭')
  end

  test "가입 인증발송" do
    post api_v1_authorizations_url( { auth: { phone: '01064184332' } } )
    name = response.parsed_body["phone"]
    assert_response :success
    assert (name == '01064184332')
  end

  test "인증하기" do
    # 유저 생성하고 인증번호 발송하기
    User.create(phone: '01064184332', email: 'alf@alfonso', name: '이원섭')
    put api_v1_authorizations_url( { auth: { phone: '01064184332' } } )
    code = response.parsed_body["result"]["code"]

    # 인증하기
    get api_v1_authorizations_url( { auth: { phone: '01064184332', code: code } } )
    verify = response.parsed_body["result"]["verify"]
    assert (verify == 'ok')
    assert_response :success

    # 인증실패
    get api_v1_authorizations_url( { auth: { phone: '01064184332', code: "wrong-#{code}" } } )
    assert_response :unauthorized

    # 인증 제한시간 초과로 인증실패
    travel 4.minutes do
      get api_v1_authorizations_url( { auth: { phone: '01064184332', code: code } } )
      assert_response :unauthorized
    end

  end
end
