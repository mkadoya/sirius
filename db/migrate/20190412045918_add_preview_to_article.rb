class AddPreviewToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :preview, :text
  end
end
