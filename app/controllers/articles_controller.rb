class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    @collection = Collection.find(params[:collection_id])
    unless current_user.collections.include?(@collection)
      redirect_to collections_path
    end
    @article = Article.new
  end

  def create
    @collection = Collection.find(params[:collection_id])
    @article = Article.new(article_params)
    @article.collections << Collection.find(params[:article][:collection_ids])
    respond_to do |format|
      if @article.save
        format.html { redirect_to collection_path(params[:article][:collection_ids]), notice: 'Article was successfully added.' }
      else
        format.html {render action: 'new' }
      end
    end
  end

  def edit
    @collection = Collection.find(params[:collection_id])
    @article = Article.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:article][:collection_ids])
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(article_params)
        format.html { redirect_to collection_path(params[:collection_id]), notice: 'Article was successfully updated.' }
      else
        format.html { render action: 'edit'}
      end
    end
  end

  def archive
    article = Article.find(params[:id])
    article.archive
    redirect_to collection_path(params[:collection_id]), notice: 'Article was successfully archived.'
  end

  def restore
    article = Article.find(params[:article_id])
    article.update(archived: false)
    redirect_to collection_path(params[:collection_id]), notice: 'Article was successfully restored.'
  end

  def upvote
    @article = Article.find(params[:article_id])
    @article.upvote
    redirect_to :back, notice: 'Article was successfully upvoted.'
  end

  def downvote
    @article = Article.find(params[:article_id])
    @article.downvote
    redirect_to :back, notice: 'Article was successfully downvoted.'
  end

  private

  def article_params
    params.require(:article).permit(:id, :title, :url, :collection_ids => [])
  end
end
