class ApiKey < ApplicationRecord
  HMAC_SECRET_KEY = ENV.fetch("API_KEY_HMAC_SECRET_KEY")

  belongs_to :user

  def self.generate_for(user)
    token = SecureRandom.urlsafe_base64
    digest = OpenSSL::HMAC.hexdigest("SHA256", HMAC_SECRET_KEY, token)
    api_token = user.api_keys.create(token_digest: digest)
    api_token.persisted? ? token : nil
  end

  def self.authenticate_by_token(token)
    find_by(token_digest: OpenSSL::HMAC.hexdigest("SHA256", HMAC_SECRET_KEY, token))
  end
end
