class QuestionsController < ApplicationController
  def index
    # 回答結果を配列に保管する
    if params[:answer]
      @answers = params[:answers]
      @answers.push(params[:answer])
    else
      @answers = ["first"]
    end

    # レコード数以上の質問になったらリザルト画面を表示する
    if params[:id].to_i <= Question.all.count
      @question = Question.find_by(id: params[:id])
    else
      @answers.shift(1)
      redirect_to :controller => "questions", :action => "result", :answers => @answers
    end
  end

  def result
    @answers = params[:answers]
  end

end
