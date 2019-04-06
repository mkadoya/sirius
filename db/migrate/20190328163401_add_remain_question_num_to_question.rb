class AddRemainQuestionNumToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :remain_question_num, :integer
  end
end
