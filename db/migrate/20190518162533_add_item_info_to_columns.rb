class AddItemInfoToColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :columns, :item_info, :boolean
  end
end
