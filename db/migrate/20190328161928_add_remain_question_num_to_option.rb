class AddRemainQuestionNumToOption < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :remain_question_num, :integer
  end
end
