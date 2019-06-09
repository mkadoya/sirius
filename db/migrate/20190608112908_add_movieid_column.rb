class AddMovieidColumn < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :movie, foreign_key: true
  end
end
