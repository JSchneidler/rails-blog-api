module Authenticate
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :user

  def authenticate
    if request.headers["Authorization"].blank?
      unauthorized_response
    else
      @user = authenticate_with_http_token &method(:token_authenticator)
    end
  end

  def authenticate_with_password
    if request.headers["Authorization"].blank?
      unauthorized_response
    else
      @user = authenticate_with_http_basic &method(:password_authenticator)
    end
  end

  private
    attr_writer :user

    def token_authenticator(token, options)
      api_key = ApiKey.authenticate_by_token(token)

      if api_key
        @user = api_key.user
      else
        unauthorized_response
      end
    end

    def password_authenticator(name, password)
      user = User.find_by(name: name)

      if user&.authenticate(password)
        @user = user
      else
        unauthorized_response
      end
    end

    def unauthorized_response
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
end
