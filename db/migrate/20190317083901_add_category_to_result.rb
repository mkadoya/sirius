class AddCategoryToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :category, :string
  end
end
