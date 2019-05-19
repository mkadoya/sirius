class RenameClusterSubColumnToPcs < ActiveRecord::Migration[5.2]
  def change
		rename_column :pcs, :cluster_sub, :cluster_2
  end
end
