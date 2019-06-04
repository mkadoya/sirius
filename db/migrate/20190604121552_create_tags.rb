class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :item_id
      t.integer :value

      t.timestamps
    end
  end
end
