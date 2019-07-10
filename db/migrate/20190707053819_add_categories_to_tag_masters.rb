class AddCategoriesToTagMasters < ActiveRecord::Migration[5.2]
  def change
    add_column :tag_masters, :categories, :string
  end
end
