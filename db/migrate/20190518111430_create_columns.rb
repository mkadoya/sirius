class CreateColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :columns do |t|
      t.string :category
      t.string :column_name
      t.string :frendly_name
      t.string :unit
      t.boolean :available
      t.boolean :dsc_better
      t.boolean :fundamental
      t.boolean :remove

      t.timestamps
    end
  end
end
