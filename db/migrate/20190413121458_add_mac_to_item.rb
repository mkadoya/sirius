class AddMacToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :mac, :boolean
  end
end
