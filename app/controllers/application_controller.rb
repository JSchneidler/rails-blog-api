class ApplicationController < ActionController::API
  def index
    render plain: "Welcome to the API!"
  end
end
