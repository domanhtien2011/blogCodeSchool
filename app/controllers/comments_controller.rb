class CommentsController < ApplicationController
  before_action :set_article
  before_action :set_comment, except: [:create]
  before_action :login_like, only:[:upvote, :downvote]
  def create
    @comment = @article.comments.create(params[:comment].permit(:name, :body))
    if @comment.save
      respond_to do |format|
        format.html { redirect_to(@article) }
        format.js # render 'create.js.erb'
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to(article_path(@article))
  end

  def upvote
   @comment.upvote_from current_user
    redirect_to(:back)
  end

  def downvote
   @comment.downvote_from current_user
    redirect_to(:back)
  end

  private

    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_comment
      @comment = @article.comments.find(params[:id])
    end

    def login_like
      if !user_signed_in?
        flash[:danger] = "You must log in to like or dislike comments!"
      end
    end
end
