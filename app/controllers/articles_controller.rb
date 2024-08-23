class ArticlesController < ApplicationController
  include Authenticate

  prepend_before_action :authenticate, except: [ :show ]

  def index
    @articles = Article.all

    response = ""
    @articles.each do |article|
      response += "#{article.id}: #{article.title}\n"
    end

    render plain: response
  end

  def show
    @article = Article.find(params[:id])

    response = "Title: #{@article.title}\nBody: #{@article.body}"
    render plain: response
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render plain: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render plain: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])

    if @article.destroy
      redirect_to action: "index", status: :see_other
    else
      render plain: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
