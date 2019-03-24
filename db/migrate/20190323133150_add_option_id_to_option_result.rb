class AddOptionIdToOptionResult < ActiveRecord::Migration[5.2]
  def change
    add_column :option_results, :option_id, :integer
  end
end
