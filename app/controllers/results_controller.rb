class ResultsController < ApplicationController
  def index

		# 手動で入れているけど、questionから引き継がれるはず。。。
		@user_id = 7
		@category = 'laptop'

		@question_count = Question.where(category: @category).count

		@num = Question.all.first.id
		@num_question = 1
		@arr_question = Array.new
		@arr_answer = Array.new

		while @num_question <= @question_count
			@arr_question << Question.find_by(id:@num).content
			@arr_answer << Result.order(updated_at: "DESC").find_by(user_id:@user_id, question_id:@num_question).answer
			@num += 1
			@num_question += 1
		end

		@pattern_pattern_id = Pattern.find_by(answer_1: @arr_answer[0], answer_2: @arr_answer[1], answer_3: @arr_answer[2], answer_4: @arr_answer[3], answer_5: @arr_answer[4], answer_6: @arr_answer[5], answer_7: @arr_answer[6], answer_8: @arr_answer[7], answer_9: @arr_answer[8], answer_10: @arr_answer[9], answer_11: @arr_answer[10],  answer_12: @arr_answer[11]).pattern_id

		@characteristic = Characteristic.find_by(category: @category, pattern_id: @pattern_pattern_id)
		@charasteristic_title = @characteristic.title
		@charasteristic_body = @characteristic.body
		@charasteristic_chara_1_str = @characteristic.chara_1_str
		@charasteristic_chara_2_str = @characteristic.chara_2_str
		@charasteristic_chara_3_str = @characteristic.chara_3_str
		@charasteristic_chara_4_str = @characteristic.chara_4_str
		@charasteristic_chara_5_str = @characteristic.chara_5_str
		@charasteristic_chara_1_val = @characteristic.chara_1_val
		@charasteristic_chara_2_val = @characteristic.chara_2_val
		@charasteristic_chara_3_val = @characteristic.chara_3_val
		@charasteristic_chara_4_val = @characteristic.chara_4_val
		@charasteristic_chara_5_val = @characteristic.chara_5_val
		@charasteristic_item_1 = @characteristic.item_1
		@charasteristic_item_2 = @characteristic.item_2
		@charasteristic_item_3 = @characteristic.item_3
		@charasteristic_item_4 = @characteristic.item_4
		@charasteristic_item_5 = @characteristic.item_5
		
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
