class ApiKeysController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, only: [ :index ]

  def index
    Rails.logger.info("User: #{@user}")
    if @user != nil
      response = ""
      @user.api_keys.each do |api_key|
        response += "Id: #{api_key.id}\n"
      end

      render plain: response
    else
      render status: :unauthorized
    end
  end

  def create
    authenticate_with_http_basic do |name, password|
      user = User.find_by(name: name)

      if user&.authenticate(password)
        token = ApiKey.generate_for(user)

        if token
          render plain: token, status: :created
        else
          render status: :unprocessable_entity
        end

        return
      end
    end

    render status: :unauthorized
  end

  def destroy
    authenticate_with_http_basic do |name, password|
      user = User.find_by(name: name)
      api_key = ApiKey.find(params[:id])

      if user&.authenticate(password)
        if api_key.destroy
          render plain: "Revoked api_key #{api_key.id} for user #{user.name}(#{user.id})"
        else
          render plain: api_key.errors.full_messages, status: :unprocessable_entity
        end
      end
    end

    render status: :unauthorized
  end
end
