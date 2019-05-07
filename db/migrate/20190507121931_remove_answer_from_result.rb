class RemoveAnswerFromResult < ActiveRecord::Migration[5.2]
  def change
    remove_column :results, :answer, :boolean
  end
end
