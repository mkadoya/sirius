class HomeController < ApplicationController
  def top
  end
  def description
  end
  def category
    @options = ["インターネット","仕事","動画視聴","デザイン","プログラミング","その他" ]
    @option1 = params[:option1]
    @option2 = params[:option2]
    @option3 = params[:option3]

  end
end
