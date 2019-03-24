class RenameColumn < ActiveRecord::Migration[5.2]
  def change
		rename_column :option_results, :option_num, :option_id
  end
end
