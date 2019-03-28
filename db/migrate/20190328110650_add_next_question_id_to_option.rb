class AddNextQuestionIdToOption < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :next_question_id, :integer
  end
end
