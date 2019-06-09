class ChangeMovieidColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :movie_id, :integer
    add_reference :tags, :movies, foreign_key: true
  end
end
