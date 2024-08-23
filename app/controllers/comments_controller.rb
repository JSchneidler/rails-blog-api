class CommentsController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, except: [ :index, :show ]

  def index
    @comments = Comment.all

    response = ""
    @comments.each do |comment|
      response += "Id: #{comment.id}, User: #{comment.user.name}, Comment: #{comment.text}\n"
    end

    render plain: response
  end

  def show
    @comment = Comment.find(params[:id])

    response = "User: #{comment.user.name}, Comment: #{comment.text}"
    render plain: response
  end

  def create
    @article = Article.find(params[:article_id])

    @comment = @article.comments.create(comment_params)

    if @comment.save
      redirect_to @comment
    else
      render plain: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to @comment
    else
      render plain: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      redirect_to root_path, status: :see_other
    else
      render plain: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text)
    end
end
