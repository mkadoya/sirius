class RemoveOptionFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :option, :boolean
  end
end
