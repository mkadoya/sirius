class AddClusterMainToPc < ActiveRecord::Migration[5.2]
  def change
    add_column :pcs, :cluster_main, :integer
  end
end
