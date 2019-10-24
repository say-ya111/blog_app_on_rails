class PagesController < ApplicationController
  def home
    @articles = Article.all
    pv_ranking = REDIS.ZREVRANGE "ranking", 0,1
    @top_articles = []
    pv_ranking.each do |rank|
      article = Article.find_by(id: rank)
      @top_articles.push(article)
    end
  end
end
