class RemoveMovieIdFromTag < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :movie_id, :integer
  end
end
