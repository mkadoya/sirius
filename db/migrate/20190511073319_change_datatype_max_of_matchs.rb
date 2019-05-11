class ChangeDatatypeMaxOfMatchs < ActiveRecord::Migration[5.2]
  def change
		    change_column :matches, :min, :string
				change_column :matches, :max, :string
  end
end
