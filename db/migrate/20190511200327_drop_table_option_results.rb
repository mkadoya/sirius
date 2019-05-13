class DropTableOptionResults < ActiveRecord::Migration[5.2]
  def change
		drop_table :option_results
		drop_table :patterns
		drop_table :userpatterns
		drop_table :characteristics
  end
end
