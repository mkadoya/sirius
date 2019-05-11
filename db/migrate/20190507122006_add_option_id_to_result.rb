class AddOptionIdToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :option_id, :integer
  end
end
