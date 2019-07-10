class AddNameToItemMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :item_masters, :name, :string
  end
end
