class HomeController < ApplicationController
  def top
    @user_id = cookies[:user_id]
    @articles = Article.order(id: :desc).first(10)
    @laptops = Item.all.last(5)
  end
  def description
  end
  def category
    @options = ["インターネット","仕事","動画視聴","デザイン","プログラミング","その他" ]
    @option1 = params[:option1]
    @option2 = params[:option2]
    @option3 = params[:option3]
  end
  def article

  end
end
