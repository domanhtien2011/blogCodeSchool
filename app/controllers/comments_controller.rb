class CommentsController < ApplicationController
  before_action :login_like, only:[:upvote]
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(params[:comment].permit(:name, :body))
    @comment.save
    redirect_to(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    redirect_to(article_path(@article))
  end

  def upvote
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
   @comment.upvote_from current_user
    redirect_to(:back)
  end

  private

    def login_like
      if !user_signed_in?
        flash[:danger] = "You must log in to like this article!"
      end
    end
end
