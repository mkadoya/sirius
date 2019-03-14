class QuestionsController < ApplicationController
  def index
    # レコード数以上の質問になったらリザルト画面を表示する
    if params[:id].to_i <= Question.all.count
      @question = Question.find_by(id: params[:id])
    else
      redirect_to("/questions/result")
    end
  end

  def result
  end

  def new
  end
end
