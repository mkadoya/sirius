class AddNextQuestionIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :next_question_id, :integer
  end
end
