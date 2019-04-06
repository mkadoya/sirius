class RemoveOptionIdFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :option_id, :integer
  end
end
