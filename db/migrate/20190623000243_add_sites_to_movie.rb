class AddSitesToMovie < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :youtube, :string
    add_column :movies, :netflix, :string
    add_column :movies, :amazonprime, :string
    add_column :movies, :hulu, :string
    add_column :movies, :filmarks, :string
  end
end
