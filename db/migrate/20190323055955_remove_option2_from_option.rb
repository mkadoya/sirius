class RemoveOption2FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option2, :text
  end
end
