class QuestionsController < ApplicationController
  def index
    # 回答結果を配列に保管する
    if params[:answer]
      @answers = params[:answers]
      @question_ids = params[:question_ids]
      @answers.push(params[:answer])
    else
      # 借りの値を1行入れる。のちに削除する。
      @answers = ["0"]
      @question_ids = ["0"]
    end

    # レコード数以上の質問になったらリザルト画面を表示する
    @answers_count = @answers.count - 1
    @questions_num = Question.where(category: "laptop").all.count

    if @answers_count < @questions_num
      @questions = Question.where(category: "laptop").all
      @question = @questions.last(@questions_num - @answers_count).first
      @question_ids.push(@question.question_id)
    else
      # 借りの1行目を削除する
      @answers.shift(1)
      @question_ids.shift(1)
      # カテゴリーの値を入れる
      @category = Question.find_by(question_id:@question_ids[0]).category
      redirect_to :controller => "questions", :action => "result", :answers => @answers, :question_ids => @question_ids, :category => @category
    end
  end

  def option_index

    # カテゴリーのフレンドリーネーム
    @category_firendly_name = "パソコン"

    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @user_id          = params[:user_id] ? params[:user_id].to_i : nil
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id = params[:next_question_id] ? params[:next_question_id].to_i : nil

    # ユーザーIDが存在しない場合は、新規ユーザーを作成する。
    if !@user_id
      redirect_to :controller => "users", :action => "create", :category => @category
    end

    # 質問数が存在しない場合は、１に設定する
    # 質問数が存在している場合は、１インクリメントする
    if !@question_num
      @question_num = 1
    else
      @question_num += 1
    end

    # 次の質問がない場合（最後の質問だった場合）、リザルト画面を表示する
    if !@next_question_id && (@question_num != 1)
      redirect_to :controller => "questions", :action => "option_result", :category => @category, :user_id => @user_id
    end

    # 次の質問が存在しない場合は、ID：１の質問を導入する
    # 次の質問が存在している場合は、そのIDの問題を導入する
    if !@next_question_id
      @question = Question.find_by(question_id: 1)
    else
      @question = Question.find_by(question_id: @next_question_id)
    end

    # 1問目でなければ前回の質問IDを導入する
    if @question_num != 1
      @before_question_id = Question.find_by(next_question_id: @question.question_id).question_id
    end

    # 選択肢を取得する
    @options = Option.where(question_id: @question.question_id).all

  end

  def result
    @answers = params[:answers]
    @question_ids = params[:question_ids]
    @category = params[:category]
  end

  def option_result
    @user_id = params[:user_id]
    @category = params[:category]
  end

end
