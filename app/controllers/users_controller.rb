class UsersController < ApplicationController
  def index
    response = ""

    users = User.all
    users.each do |user|
      response += "#{user_info(user)}\n"
    end

    render plain: response
  end

  def show
    user = User.find(params[:id])

    show_user(user)
  end

  def create
    user = User.new(user_params)

    if user.save
      redirect_to user
    else
      render plain: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      show_user(user)
    else
      render plain: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    user_info = "#{user.name}(#{user.id})"

    if user.destroy
      render plain: "Deleted user: #{user_info}"
    else
      render plain: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:name, :password)
    end

    def user_info(user)
      "Name(ID): #{user.name}(#{user.id}), Article Count: #{user.articles.length}, Comment Count: #{user.comments.length}"
    end

    def show_user(user)
      render plain: user_info(user)
    end
end
