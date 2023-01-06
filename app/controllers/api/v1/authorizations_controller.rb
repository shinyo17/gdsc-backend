require "jwt_auth"
class Api::V1::AuthorizationsController < Api::V1::BaseController
  def update
    # 로그인
    @user = User.find_by_phone(login_params[:phone])
    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end
    result = PhoneAuthService.call(login_params)
    @result = result.except("groupId", "statusMessage", "messageId", "accountId")
    render status: @status
  end

  def create
    # /api/v1/authorizations POST (폰 번호 입력 후 메시지 전송)
    @user = User.find_or_create_by!(phone: login_params[:phone])
    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end
    result = PhoneAuthService.call(login_params)
    @result = result.except("groupId", "statusMessage", "messageId", "accountId")
    render status: @status
  end

  def show
    # /api/v1/authorizations GET (폰 번호와 코드를 받아 번호 인증)
    @user = User.find_by_phone(login_params[:phone])
    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end
    result = PhoneAuthService.call(login_params)
    if result == false
      error!('unauthorized', :unauthorized) and return
    end
    @result = result
    @user.update(phone_verified_at: Time.current) if result[:verify] == "ok"
    # @access_token, @refresh_token = JwtAuth.issue(@user)
    render status: @status
  end

  def delete
  end

  def check_signed_up
    # /api/v1/authorizations/check_signed_up
    # (폰 번호와 코드를 받아 번호 인증 후 가입되어 있는지 확인)
    @user = User.find_by_phone(login_params[:phone])

    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end

    render status: @status
  end

  def login
    # /api/v1/authorizations/login
    # (폰 번호와 코드를 받아 번호 인증 후 가입되어 있는지 확인 이후 가입돼 있다면 로그인)
    basic_token = request.headers["Authorization"].split(" ")[1]
    decoded = Base64.decode64(basic_token)
    phone = decoded.split(":")[0]

    @user = User.find_by_phone(phone)

    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end

    @access_token, @refresh_token = JwtAuth.issue(@user)
    render status: @status
  rescue StandardError => e
    error!(e.message, :unauthorized)
  end

  def sign_up
    # /api/v1/authorizations/sign_up
    # (폰 번호와 코드를 받아 번호 인증 후 가입되어 있는지 확인 이후 가입돼 있지 않다면 회원가입)
    basic_token = request.headers["Authorization"].split(" ")[1]
    decoded = Base64.decode64(basic_token)
    phone = decoded.split(":")[0]

    @user = User.find_by_phone(phone)

    if @user.nil?
      error!('unauthorized', :unauthorized) and return
    end

    @user.terms_accepted_at = sign_up_params[:terms_accepted_at]
    @user.save

    @access_token, @refresh_token = JwtAuth.issue(@user)
    render status: @status
  rescue StandardError => e
    error!(e.message, :unauthorized)
  end

  def token_refresh
    # /api/v1/authorizations/token_refresh
    # (Access Token이 만료된 경우, refresh token을 이용해서 JWT 토큰들을 다시 발급해 준다.)
    @access_token, @refresh_token = JwtAuth.refresh(headers: request.headers)
  end

  private

  def login_params
    params.require(:auth).permit(:phone, :code)
  end

  def sign_up_params
    params.require(:auth).permit(:terms_accepted_at, :marketing_accepted_at)
  end
end
