class QuestionsController < ApplicationController
  def index
    # カテゴリーのフレンドリーネーム
    @category_firendly_name = "パソコン"

    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id = params[:next_question_id] ? params[:next_question_id].to_i : nil
    @user_id          = cookies[:user_id]

    @start_question_id = Question.find_by(category: @category).question_id

    # Cookie情報がない場合、新規ユーザーを作成する。
    if !@user_id
      @new_user_id = TempUser.order(user_id: "DESC").first.user_id + 1
      @new_user_name = "Guest"
      @user = TempUser.create(user_id: @new_user_id, name:@new_user_name)
      @user.save
      cookies.permanent[:user_id] = { :value => @new_user_id}
      redirect_to :controller => "questions", :action => "index", :category => @category and return
      # redirect_to :controller => "users", :action => "create", :category => @category
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
		      option_id = OptionResult.find_by(user_id:@user_id, question_id:@start_question_id, result:true).option_id
          @n_question_id = Option.find_by(option_id:option_id).next_question_id
          @before_question_id = Option.find_by(option_id:option_id).question_id
        else
          option_id = OptionResult.find_by(user_id:@user_id, question_id:@n_question_id, result:true).option_id
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

    # #全部のルートの格納方法
    # @all_options = Option.where(category:@category).all

    # @all_options.each |option| do
    #   @option_arrow = {s: option.question_id, d:option.next_question_id}
    #   if !@option_arrows
    #     @option_arrows = [@option_arrow]
    #   else
    #     @option_arrows.push(@option_arrow)
    #   end
    # end

    # @option_arrows = @option_arrows.uniq

    # #コスト計算
    # @cost = {q:1, cost:1, fix:true}
    # @costs = [@cost]
    # while(@option_arrows.count != 0)
    #   @costs.each |cost| do
    #     if cost[:fix]
    #       @option_arrows.each |option_arrow| do
    #         if option_arrow[:s] == cost[:q]
    #           cost = {q:option_arrow[:d],cost:cost[:cost],fix:false}
    #           @costs.push(cost)
    #           @option_arrows.delete(option_allow)
    #         end
    #       end
    #       @costs |cost| do
    #         @option_arrows.each |option_arrow| do
    #           counter = 0
    #           if option_arrow[:d] == cost[:q]
    #             counter += 1
    #           end
    #           if counter ==0
    #             new_cost == {q:cost[:q],cost:cost[:cost],fix:cost[:fix]}
    #             @costs.delete(cost)
    #             @costs.push(new_cost)
    #           end
    #         end
    #       end
    #     end
    #   end
    # end



    # 選択肢を取得する
    @options = Option.where(question_id: @question.question_id).all

    # 20190324　アップデート前

    # # 回答結果を配列に保管する
    # if params[:answer]
    #   @answers = params[:answers]
    #   @question_ids = params[:question_ids]
    #   @answers.push(params[:answer])
    # else
    #   # 借りの値を1行入れる。のちに削除する。
    #   @answers = ["0"]
    #   @question_ids = ["0"]
    # end

    # # レコード数以上の質問になったらリザルト画面を表示する
    # @answers_count = @answers.count - 1
    # @questions_num = Question.where(category: "laptop").all.count

    # if @answers_count < @questions_num
    #   @questions = Question.where(category: "laptop").all
    #   @question = @questions.last(@questions_num - @answers_count).first
    #   @question_ids.push(@question.question_id)
    # else
    #   # 借りの1行目を削除する
    #   @answers.shift(1)
    #   @question_ids.shift(1)
    #   # カテゴリーの値を入れる
    #   @category = Question.find_by(question_id:@question_ids[0]).category
    #   redirect_to :controller => "questions", :action => "result", :answers => @answers, :question_ids => @question_ids, :category => @category
    # end
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
