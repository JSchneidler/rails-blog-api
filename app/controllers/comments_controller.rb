class CommentsController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, except: [ :index, :show ]

  def index
    comments = Comment.all

    response = ""
    comments.each do |comment|
      response += "#{comment_info(comment)}\n"
    end

    render plain: response
  end

  def show
    comment = Comment.find(params[:id])

    show_comment(comment)
  end

  def create
    comment = @user.articles.find(params[:article_id]).comments.new(comment_params)
    comment.author_id = @user.id

    if comment.save
      # TODO: Fix
      redirect_to comment
    else
      render plain: comment.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  def update
    comment = @user.articles.find(params[:article_id]).comments.find(params[:id])

    if comment.update(comment_params)
      show_comment(comment)
    else
      render plain: comment.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  def destroy
    comment = @user.articles.find(params[:article_id]).comments.find(params[:id])

    if comment.destroy
      render plain: "Deleted comment #{comment.id} on article #{comment.article.id}"
    else
      render plain: comment.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.permit(:body)
    end

    def comment_info(comment)
      "Id: #{comment.id}\nAuthor: #{comment.user.name}(#{comment.user.id})\nText: #{comment.body}\n"
    end

    def show_comment(comment)
      render plain: comment_info(comment)
    end
end
