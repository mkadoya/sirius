class RemoveNextQuestionIdFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :next_question_id, :integer
  end
end
