class RenameClusterMainColumnToPcs < ActiveRecord::Migration[5.2]
  def change
		rename_column :pcs, :cluster_main, :cluster_1
  end
end
