class ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @user_id = cookies[:user_id].presence || 0
    @articles = Article.order(id: :desc).all
    @result_displayed = false
    @article_howtouse = Article.find_by(id:1)
    @categories = {}

    # 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
      category_array = Result.where(user_id:@user_id).pluck(:category).uniq
      category_array.each do |category|
        name = Category.find_by(category: category).name
        @categories[category] = name
      end
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @user_id = cookies[:user_id].presence || 0
    @articles = Article.order(id: :desc).first(10)
    @result_displayed = false
    @categories = {}
    # 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
      category_array = Result.where(user_id:@user_id).pluck(:category).uniq
      category_array.each do |category|
        name = Category.find_by(category: category).name
        @categories[category] = name
      end
    end
  end

  # GET /articles/new
  def new
    redirect_to '/admin'
  end

  # GET /articles/1/edit
  def edit
    redirect_to '/admin'
  end

  # POST /articles
  # POST /articles.json
  def create
    redirect_to '/admin'
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
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
    redirect_to '/admin'
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
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
    redirect_to '/admin'
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :image, :preview)
    end
end
