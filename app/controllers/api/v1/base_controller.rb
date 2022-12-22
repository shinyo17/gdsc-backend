class Api::V1::BaseController < Api::ApiController
  layout 'api/v1/base'
  before_action :setup_layout_elements

  def setup_layout_elements
    @status = :ok
    @errors = nil
  end

  def error!(message, status = :internal_server_error)
    @status = status
    @messages = ([] << message).flatten
    render 'api/v1/shared/error', status: status
  end

  def pagination!(page, count, has_more, data)
    @page = page
    @count = count
    @has_more = has_more
    @data = data
    render 'api/v1/shared/pagination'
  end

  private

  def authenticate
    current_user, decoded_token = JwtAuth.authenticate(
      headers: request.headers,
      access_token: params[:access_token] # authenticate from header OR params
    )

    @current_user = current_user
    @decoded_token = decoded_token
  rescue JwtAuth::Error::AccessTokenExpiredSignature => e
    @token_type = 'access_token'
    error!(e.message, :unauthorized)
  rescue StandardError => e
    error!(e.message, :unauthorized)
  end
end
