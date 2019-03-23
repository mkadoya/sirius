class RemoveOption3FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option3, :text
  end
end
