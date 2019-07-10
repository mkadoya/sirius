class RenameMovieIdColumnToItemId < ActiveRecord::Migration[5.2]
  def change
      rename_column :tags, :movie_id, :item_id
  end
end
