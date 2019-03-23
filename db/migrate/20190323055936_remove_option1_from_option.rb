class RemoveOption1FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option1, :text
  end
end
