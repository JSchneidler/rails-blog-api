class ApiKey < ApplicationRecord
  belongs_to :user

  has_secure_password :token, validations: false

  def self.generate_for(user)
    token = SecureRandom.urlsafe_base64
    api_token = user.api_keys.create(token: token)
    api_token.persisted? ? token : nil
  end
end
