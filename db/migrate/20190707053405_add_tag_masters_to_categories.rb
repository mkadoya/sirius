class AddTagMastersToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :categories, :string
  end
end
