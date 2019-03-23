class OptionsController < ApplicationController
  def get
    @question_id = 1
    @options = Option.where(question_id: @question_id ).all
    @option_num = @options.count
  end
end
