class UsersController < ApplicationController
  def show
  end
  def create
    # カテゴリーを入れる（いずれ廃止）
    @category = params[:category]

    # ユーザーIDを新規取得、名前をテストユーザーとして登録する（いずれ廃止）
    @new_user_id = User.order(user_id: "DESC").first.user_id + 1
    @new_user_name = "Guest"

    # ユーザーを作成
    @user = User.create(user_id: @new_user_id, name:@new_user_name)
    @user.save

    # 質問一覧に戻る
    redirect_to :controller => "questions", :action => "index", :user_id => @user.user_id, :category => @category
    # 20190324 アップデート前
    # redirect_to :controller => "questions", :action => "option_index", :user_id => @user.user_id, :category => @category
  end
end
