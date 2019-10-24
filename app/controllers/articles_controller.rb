class ArticlesController < ApplicationController
  before_action :currect_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :destroy]

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    @article.save
    redirect_to @article
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
    @article.update_score
    pv_ranking = REDIS.ZREVRANGE "ranking", 0,1
    @top_articles = []
    pv_ranking.each do |rank|
      article = Article.find_by(id: rank)
      @top_articles.push(article)
    end
  end

  def edit
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(article_params)
    redirect_to @article
  end

  def destroy
    Article.find(params[:id]).destroy
    redirect_to root_url
    REDIS.ZREM "ranking", params[:id]
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def currect_user
    @article = Article.find(params[:id])
    unless current_user.id == @article.user_id
      flash[:alert] = "not yours"
      redirect_to root_path
    end
  end

  def logged_in_user
    if current_user == nil
      redirect_to root_url
    end
  end
end
