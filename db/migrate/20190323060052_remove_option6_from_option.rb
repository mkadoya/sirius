class RemoveOption6FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option6, :text
  end
end
