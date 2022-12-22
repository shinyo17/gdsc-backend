require 'net/http'
require 'solapi_request'

class SendMmsMessageService
  include SolapiRequest
  attr_reader :message

  def initialize(message = {})
    @message = message
  end

  # message 로 받는 사람 번호와 내용을 전달하면 mms 가 발송된다.
  #
  # ==== Examples
  #
  #   message = {:to=>"01064184332", :text=>"인증번호는 511446"}
  #   SendMmsMessageService.call(message)

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    response = message_post({ message: message })
    response
  end
end