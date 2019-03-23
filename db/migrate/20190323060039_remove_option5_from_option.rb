class RemoveOption5FromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :option5, :text
  end
end
