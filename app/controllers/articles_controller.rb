class ArticlesController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, except: [ :index, :show ]

  def index
    articles = Article.all

    response = ""
    articles.each do |article|
      response += "#{article_info(article)}\n"
    end

    render plain: response
  end

  def show
    article = Article.find(params[:id])

    show_article(article)
  end

  def create
    article = @user.articles.new(article_params)

    if article.save
      redirect_to article
    else
      render plain: article.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  def update
    article = @user.articles.find(params[:id])

    if article.update(article_params)
      show_article(article)
    else
      render plain: article.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  def destroy
    article = @user.articles.find(params[:id])

    article_info = "#{article.title}(#{article.id})"

    if article.destroy
      render plain: "Deleted article: #{article_info}"
    else
      render plain: article.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.permit(:title, :body)
    end

    def article_info(article)
      "Id: #{article.id}\nAuthor: #{article.user.name}(#{article.user.id})\nTitle: #{article.title}\nBody: #{article.body}\nComments: #{article.comments.length}\n"
    end

    def show_article(article)
      render plain: article_info(article)
    end
end
