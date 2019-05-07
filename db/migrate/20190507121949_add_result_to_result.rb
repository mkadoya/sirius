class AddResultToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :result, :boolean
  end
end
