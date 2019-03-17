class ResultsController < ApplicationController
  def index
		@question_count = Question.all.count
		@user_id = Result.find_by(user_id:3).user_id

		@num = 1
		@arr_question = Array.new
		@arr_answer = Array.new

		while @num <= @question_count
			@arr_question << Question.find_by(id:@num).content
			@arr_answer << Result.order(updated_at: "DESC").find_by(user_id:@user_id, question_id:@num).answer
			@num += 1
		end

		@result_pattern = Pattern.find_by(answer_1: @arr_answer[0], answer_2: @arr_answer[1], answer_3: @arr_answer[2], answer_4: @arr_answer[3], answer_5: @arr_answer[4], answer_6: @arr_answer[5], answer_7: @arr_answer[6], answer_8: @arr_answer[7], answer_9: @arr_answer[8], answer_10: @arr_answer[9], answer_11: @arr_answer[10],  answer_12: @arr_answer[11]).pattern_id

  end

  def index2
		@answers = params[:answers]
  end

#   def create
# 		@answers = params[:answers]
# 		@result = Result.order(updated_at: "DESC").first
# 		if @result.nil?
# 			@user_id = 1
# 		else
# 			@user_id = @result.user_id.to_i + 1
# 		end
# 		@question_num = 0

# 		@answers.each do |answer|
# 			if @results.nil?
# 				@results = {user_id => @user_id, question_id => @question_num, answer => answer }
# 				@results_array = [@results]
# 				@question_num += 1
# 			else
# 				@results.
# 			end
# 		end
#   end
end
