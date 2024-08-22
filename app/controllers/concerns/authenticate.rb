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
      @api_key = ApiKey.find_by(token_digest: BCrypt::Password.create(token))
      api_key? ? api_key.user : nil
    end
end
