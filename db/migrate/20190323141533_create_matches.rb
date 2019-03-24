class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :match_id
      t.string :category
      t.integer :option_id
      t.string :item_clmn
      t.float :min
      t.float :max

      t.timestamps
    end
  end
end
