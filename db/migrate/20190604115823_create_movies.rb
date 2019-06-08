class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :outline
      t.string :director
      t.text :performer
      t.integer :year
      t.string :preview
      t.string :image
      t.string :article
      t.string :movie

      t.timestamps
    end
  end
end
