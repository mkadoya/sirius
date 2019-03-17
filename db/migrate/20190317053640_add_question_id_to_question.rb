class AddQuestionIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :question_id, :integer
  end
end
