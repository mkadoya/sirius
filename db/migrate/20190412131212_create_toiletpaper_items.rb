class CreateToiletpaperItems < ActiveRecord::Migration[5.2]
  def change
    create_table :toiletpaper_items do |t|
      t.integer :item_id
      t.string :category
      t.string :maker
      t.text :name
      t.integer :price
      t.boolean :single
      t.boolean :double
      t.integer :cost
      t.integer :soft
      t.integer :flavor
      t.integer :smooth
      t.integer :water
      t.boolean :design
      t.integer :fun
      t.text :series
      t.text :affiliate
      t.text :image

      t.timestamps
    end
  end
end
