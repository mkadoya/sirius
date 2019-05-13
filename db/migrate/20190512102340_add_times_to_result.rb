class AddTimesToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :times, :integer
  end
end
