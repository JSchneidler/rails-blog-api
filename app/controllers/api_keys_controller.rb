class ApiKeysController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, only: [ :index ]
  prepend_before_action :authenticate_with_password, only: [ :create, :destroy ]

  def index
    response = ""
    @user.api_keys.each do |api_key|
      response += "Id: #{api_key.id}\n"
    end

    render plain: response
  end

  def create
    token = ApiKey.generate_for(@user)

    if token
      render plain: token, status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    api_key = @user.api_keys.find(params[:id])

    if api_key.destroy
      render plain: "Revoked api_key #{api_key.id} for user #{api_key.user.name}(#{api_key.user.id})"
    else
      render plain: api_key.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end
end
