class ChangeDatatypeMinOfMatches < ActiveRecord::Migration[5.2]
  def change
		change_column :matches, :min, :float
		change_column :matches, :max, :float
  end
end
