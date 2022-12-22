class PhoneAuthService
  attr_reader :params, :found_user
  def initialize(params = {})
    @params = params
    @found_user = request_user
  end

  # params 로 전화번호를 전달하면 인증코드가 발송된다.
  # 전화번호와 인증코드를 같이 전달하면 인증결과를 전달한다.
  #
  # ==== Examples
  #
  #   params = { phone: '01064184332' }
  #   PhoneAuthService.call(params)
  #
  #   params = { phone: '010', code: '111222' }
  #   PhoneAuthService.call(params)

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    raise ArgumentError, "전화번호 넣어주세요" if params[:phone].nil?

    if params[:code].present?
      verify
    else
      send_message
    end
  end

  private

  def validate_제한시간
    3.minutes
  end

  def minimum_발송간격
    30.second
  end

  def verify
    발송시간 = Time.zone.parse last_log["created_at"] if last_log["created_at"].present?
    return false if 발송시간 + validate_제한시간 <= Time.current
    result = {verify: "ok"}
    return result if last_log["code"] == params[:code]
    false
  end

  def guide_text
    sent_code = last_log["code"]
    "인증번호는 #{sent_code}"
  end

  def send_message
    saved_log
    if Rails.env.test?
    # if false
      response = built_message
    else
      message = built_message
      message.delete(:code)
      # response = SendMmsMessageService.call(message)
      response = built_message
    end
    response
  end

  def last_log
    found_user.phone_verified_log[-1]
  end

  def request_user
    users = User.where(phone: params[:phone])
    raise ActiveRecord::RecordNotFound if users.empty?
    users.order(created_at: :desc).first
  end

  def too_often?
    too_often = true
    if last_log.nil?
      too_often = false
    else
      created_at = Time.zone.parse(last_log["created_at"])
      too_often = created_at + minimum_발송간격 > Time.current
    end
    raise TooOftenVerifying if too_often
    too_often
  end

  def saved_log
    user = found_user
    log = { code: code, created_at: Time.current }
    unless too_often?
      user.phone_verified_log << log
      user.save
    end
    user.phone_verified_log
  end

  def built_message
    to = params[:phone]
    message = { to: to, text: guide_text, code: last_log["code"]}
  end

  def code
    result = []
    6.times do
      result << [1, 2, 3, 4, 5, 6].sample
    end
    result.join
  end

  class TooOftenVerifying < StandardError
  end
end
