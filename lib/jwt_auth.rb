module JwtAuth
  module_function

  ACCESS_TOKEN_EXPIRY = 2.weeks
  REFRESH_TOKEN_EXPIRY = 4.weeks

  def authenticate(headers:, access_token:)
    token = access_token || authenticate_header(headers)
    raise JwtAuth::Error::TokenNotFound if token.blank?

    decoded_token = decode(token)
    user = authenticate_user_from_token(decoded_token)
    raise JwtAuth::Error::UserNotFound if user.blank?

    [user, decoded_token]
  end

  def authenticate_header(headers)
    headers['Authorization']&.split('Bearer ')&.last
  end

  def authenticate_user_from_token(decoded_token)
    raise JwtAuth::Error::InvalidToken if decoded_token[:exp].blank? || decoded_token[:user_id].blank?

    User.find(decoded_token.fetch(:user_id))
  end

  def encode(user, token_type: :access_token)
    JWT.encode(
      {
        user_id: user.id,
        jti: SecureRandom.hex,
        iat: Time.now.to_i,
        exp: token_expiry(token_type: token_type)
      },
      secret(token_type: token_type)
    )
  end

  def token_expiry(token_type: :access_token)
    exp = token_type == :access_token ? ACCESS_TOKEN_EXPIRY : REFRESH_TOKEN_EXPIRY
    (Time.now + exp).to_i
  end

  def issue(user)
    [
      encode(user, token_type: :access_token),
      encode(user, token_type: :refresh_token)
    ]
  end

  def decode(token, token_type: :access_token)
    token_secret = secret(token_type: token_type)
    decoded = JWT.decode(token, token_secret, true, verify_iat: true)[0]
    raise JwtAuth::Error::InvalidToken unless decoded.present?

    decoded.symbolize_keys
  rescue JWT::ExpiredSignature
    error = token_type == :access_token ? JwtAuth::Error::AccessTokenExpiredSignature : JwtAuth::Error::RefreshTokenExpiredSignature
    raise error
  end

  def refresh(headers:, refresh_token:)
    token = refresh_token || authenticate_header(headers)
    raise JwtAuth::Error::TokenNotFound unless token.present?
    decoded_token = decode(token, token_type: :refresh_token)
    raise JwtAuth::Error::TokenNotFound, token: 'refresh' if decoded_token.nil?

    user = user_from_token(decoded_token)

    new_access_token, new_refresh_token = issue(user)

    [new_access_token, new_refresh_token]
  end

  def user_from_token(decoded_token)
    raise JwtAuth::Error::InvalidToken if decoded_token[:exp].blank? || decoded_token[:user_id].blank?

    User.find(decoded_token.fetch(:user_id))
  end

  def secret(token_type: :access_token)
    Rails.application.credentials.jwt["#{token_type}_key".to_sym]
  end

  module Error
    class TokenError < StandardError; end

    class UserNotFound < TokenError
      def message
        'User not found'
      end
    end

    class TokenNotFound < TokenError
      def message
        'Token not found'
      end
    end

    class InvalidToken < TokenError
      def message
        'Invalid token'
      end
    end

    class AccessTokenExpiredSignature < JWT::ExpiredSignature
      def message
        'Access token signature has expired'
      end
    end

    class RefreshTokenExpiredSignature < JWT::ExpiredSignature
      def message
        'Refresh token signature has expired'
      end
    end
  end

end
