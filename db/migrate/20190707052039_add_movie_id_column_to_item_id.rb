class AddMovieIdColumnToItemId < ActiveRecord::Migration[5.2]
  def change
    rename_column :tags, :item_id, :movie_id
  end
end
