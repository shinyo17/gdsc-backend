require "jwt_auth"
class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate, except: [:create]
  before_action :find_user, except: %i[create index]

  def index
    @user = @current_user
    render status: @status
  rescue ActiveRecord::RecordInvalid
    error!(@user.errors.full_messages, :unprocessable_entity)
  rescue StandardError => e
    error!(e, e.class.name.demodulize)
  end

  def create
    @user = User.new(user_params)
    @user.save!
    @access_token, @refresh_token = JwtAuth.issue(@user)
    @status = :created
    render status: @status
  rescue ActiveRecord::RecordInvalid
    error!(@user.errors.full_messages, :unprocessable_entity)
  rescue StandardError => e
    error!(e, e.class.name.demodulize)
  end

  def update
    return unless @user.phone == update_user_params[:phone]

    @user.update(username: update_user_params[:username])
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error!('User not found', :not_found)
  end

  def user_params
    params
      .require(:user)
      .permit(:username, :email, :password, :fcm_token, :marketing_target)
  end

  def update_user_params
    params
      .require(:user)
      .permit(:phone, :username)
  end
end
