class CreateItemMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :item_masters do |t|
      t.string :category
      t.integer :item_id

      t.timestamps
    end
  end
end
