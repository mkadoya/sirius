class AddTagsToItemMasters < ActiveRecord::Migration[5.2]
  def change
    add_column :item_masters, :tags, :string
  end
end
