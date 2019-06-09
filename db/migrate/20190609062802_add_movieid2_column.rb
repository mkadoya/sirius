class AddMovieid2Column < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :movies_id, :integer
    add_reference :tags, :movie, foreign_key: true
  end
end
