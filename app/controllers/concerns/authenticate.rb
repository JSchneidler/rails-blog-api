module Authenticate
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :api_key
  attr_reader :user

  def authenticate
    @user = authenticate_with_http_token &method(:authenticator)
  end

  private
    attr_writer :api_key
    attr_writer :user

    def authenticator(token, options)
      api_key = ApiKey.authenticate_by_token(token)
      Rails.logger.info("Key: #{api_key}")
      if api_key
        @user = api_key.user
      end
    end
end
