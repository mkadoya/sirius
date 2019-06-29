class RemoveItemIdFromMovie < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :item_id, :integer
  end
end
