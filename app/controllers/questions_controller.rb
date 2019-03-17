class QuestionsController < ApplicationController
  def index
    # 回答結果を配列に保管する
    if params[:answer]
      @answers = params[:answers]
      @answers.push(params[:answer])
    else
      @answers = ["0"]
    end

    # レコード数以上の質問になったらリザルト画面を表示する
    @answers_count = @answers.count - 1
    @questions_num = Question.where(category: "laptop").all.count

    if @answers_count < @questions_num
      @questions = Question.where(category: "laptop").all
      @question = @questions.last(@questions_num - @answers_count).first
    else
      @answers.shift(1)
      redirect_to :controller => "results", :action => "index2", :answers => @answers
    end

    # if params[:id].to_i <= Question.all.count
    #   @question = Question.find_by(id: params[:id])
    # else
    #   @answers.shift(1)
    #   redirect_to :controller => "results", :action => "index2", :answers => @answers
    # end

  end
end
