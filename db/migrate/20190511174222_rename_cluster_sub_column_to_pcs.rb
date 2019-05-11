class RenameClusterSubColumnToPcs < ActiveRecord::Migration[5.2]
  def change
		rename_column :pcs, :cluster_1, :cluster_2
		rename_column :pcs, :cluster_0, :cluster_1
  end
end
