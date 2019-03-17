class QuestionsController < ApplicationController
  def index
    # 回答結果を配列に保管する
    if params[:answer]
      @answers = params[:answers]
      @question_ids = params[:question_ids]
      @answers.push(params[:answer])
    else
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
      @answers.shift(1)
      @question_ids.shift(1)
      redirect_to :controller => "questions", :action => "result", :answers => @answers, :question_ids => @question_ids
    end
  end

  def result
    @answers = params[:answers]
    @question_ids = params[:question_ids]
  end

end
