class AddImageToItemMasters < ActiveRecord::Migration[5.2]
  def change
    add_column :item_masters, :image, :string
  end
end
