class RemoveOptionNumFromOptionResult < ActiveRecord::Migration[5.2]
  def change
    remove_column :option_results, :option_num, :integer
  end
end
