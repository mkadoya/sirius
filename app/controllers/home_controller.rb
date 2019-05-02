class HomeController < ApplicationController
  def top
    @user_id = cookies[:user_id].presence || 0
    @articles = Article.order(id: :desc).first(10)
    @laptops = Item.all.last(5)
    @result_displayed = false

    # 結果の表示判定
    if (OptionResult.where(user_id: @user_id).count > 0)
      @result_displayed = true
    end
  end
end
