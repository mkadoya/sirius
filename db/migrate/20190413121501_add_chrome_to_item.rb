class AddChromeToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :chrome, :boolean
  end
end
