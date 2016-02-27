class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show, :upvote]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :login_like, only: [:upvote]
  impressionist actions: [:show]

  # GET /articles
  # GET /articles.json
  def index
    if params[:search].present?
      @articles = Article.search(params[:search]).order('created_at DESC')
      if params[:tag]
        @articles = Article.tagged_with(params[:tag])
      end
    else
      @articles = Article.all.order('created_at DESC')
      if params[:tag]
        @articles = Article.tagged_with(params[:tag])
      end
    end
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.build(article_params)

    respond_to do |format|
      if @article.save
        flash[:success] = 'Article was successfully created.'
        format.html { redirect_to @article}
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        flash[:success] = 'Article was successfully updated.'
        format.html { redirect_to @article }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    flash[:danger] = 'Article was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  def upvote
    @article.upvote_from current_user
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body, :tag_list)
    end

    def require_same_user
      if current_user.id != @article.user_id
        flash[:danger] = "You can only edit or delete your own articles!"
        redirect_to(root_path)
      end
    end

    def login_like
      if !user_signed_in?
        flash[:danger] = "You must log in to like this article!"
      end
    end
end
