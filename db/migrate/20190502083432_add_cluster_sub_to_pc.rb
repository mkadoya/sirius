class AddClusterSubToPc < ActiveRecord::Migration[5.2]
  def change
    add_column :pcs, :cluster_sub, :integer
  end
end
