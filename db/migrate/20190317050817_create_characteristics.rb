class CreateCharacteristics < ActiveRecord::Migration[5.2]
  def change
    create_table :characteristics do |t|
      t.string :category
      t.integer :pattern_id
      t.string :title
      t.text :body
      t.text :chara_1_str
      t.integer :chara_1_val
      t.text :chara_2_str
      t.integer :chara_2_val
      t.text :chara_3_str
      t.integer :chara_3_val
      t.text :chara_4_str
      t.integer :chara_4_val
      t.text :chara_5_str
      t.integer :chara_5_val
      t.integer :item_1
      t.integer :item_2
      t.integer :item_3
      t.integer :item_4
      t.integer :item_5

      t.timestamps
    end
  end
end
