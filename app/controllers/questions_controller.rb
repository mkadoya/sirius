class QuestionsController < ApplicationController
  def index
    # カテゴリーのフレンドリーネーム
    @category_firendly_name = "パソコン"

    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id = params[:next_question_id] ? params[:next_question_id].to_i : nil
    @user_id          = cookies[:user_id].presence || 0
    @start_question_id = Question.find_by(category: @category).question_id
    @result_displayed = false

    # 記事のインポート
    @articles = Article.all

    # Cookie情報がない場合、新規ユーザーを作成する。
    if @user_id == 0

			# 最初のユーザの場合には、@new_user_idとして1を設定
      if TempUser.first.nil? == true
        @new_user_id = 1
			# 2番以降のUserは、既存のUser-idの一番大き奴に1足したIDにする
      else
        @new_user_id = TempUser.order(user_id: "DESC").first.user_id + 1
      end
      @new_user_name = "Guest"
      @user = TempUser.create(user_id: @new_user_id, name:@new_user_name)
      @user.save
      cookies.permanent[:user_id] = { :value => @new_user_id}
      redirect_to :controller => "questions", :action => "index", :category => @category and return
      # redirect_to :controller => "users", :action => "create", :category => @category
    end

    # 結果の表示判定
    if (OptionResult.where(user_id: @user_id).count > 0)
      @result_displayed = true
    end

    # 質問数が存在しない場合は、１に設定する
    # 質問数が存在している場合は、１インクリメントする
    if !@question_num
      @question_num = 1
    else
      @question_num += 1
    end

    # 1問目でなければ前回の質問IDを導入する
    if @question_num != @start_question_id
      range = Range.new(1, @question_num-1)
      range.each do |num|
	      if num==1
					# 最初のUserの時は空なので、
					if OptionResult.find_by(user_id:@user_id, question_id:@start_question_id, result:true).nil? == true
						option_id = 2
					else
		      	option_id = OptionResult.find_by(user_id:@user_id, question_id:@start_question_id, result:true).option_id
					end
          @n_question_id = Option.find_by(option_id:option_id).next_question_id
          @before_question_id = Option.find_by(option_id:option_id).question_id
        else
					if OptionResult.find_by(user_id:@user_id, question_id:@start_question_id, result:true).nil? == true
						option_id = 2
					else
          	option_id = OptionResult.find_by(user_id:@user_id, question_id:@n_question_id, result:true).option_id
					end
          @n_question_id = Option.find_by(option_id:option_id).next_question_id
          @before_question_id = Option.find_by(option_id:option_id).question_id
        end
      end
    #   @before_question_id = Question.find_by(next_question_id: @question.question_id).question_id
    end

    # 次の質問がない場合（最後の質問だった場合）、リザルト画面を表示する
    if @next_question_id==0
      # redirect_to :controller => "results", :action => "index", :category => @category and return
      # question_numがmax_question_num+1のため
      @max_question_num = @question_num - 1
      return
    end

    # 次の質問が存在しない場合は、ID：１の質問を導入する
    # 次の質問が存在している場合は、そのIDの問題を導入する
    if !@next_question_id
      @question = Question.find_by(question_id: @start_question_id)
    else
      @question = Question.find_by(question_id: @next_question_id)
    end

    # 最大質問数
    @max_question_num = @question_num + @question.remain_question_num

    # 選択肢を取得する
    @options = Option.where(question_id: @question.question_id).all

  end

  def result
    @user_id = cookies[:user_id]
    @category = params[:category]
    # 20190324 アップデート前
    # @answers = params[:answers]
    # @question_ids = params[:question_ids]
    # @category = params[:category]
  end

end
