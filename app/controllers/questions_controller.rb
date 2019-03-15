class QuestionsController < ApplicationController
  def index

    if params[:answer]
      @answers = params[:answers]
      @answers.push(params[:answer])
      # @answers.store(params[:id], params[:answer])
      @test = "OLD"
    else
      @answers = ["true"]
      @hash = {:question_id => 0, :answer => true}
      @test = "NEW"
    end

    if params[:hash_answer]
      @hash = params[:hash]
      @TEST = "hash"
    end


    # レコード数以上の質問になったらリザルト画面を表示する
    if params[:id].to_i <= Question.all.count
      @question = Question.find_by(id: params[:id])
    else
      redirect_to("/questions/result")
    end
  end

  def result

  end

end
