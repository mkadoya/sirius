class RemoveOption4FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option4, :text
  end
end
