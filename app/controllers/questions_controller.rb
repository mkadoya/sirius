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

  def result
    @answers = params[:answers]
    @question_ids = params[:question_ids]
    @category = params[:category]
  end

end
