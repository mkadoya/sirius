class RemoveRemainQuestionNumFromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :remain_question_num, :integer
  end
end
