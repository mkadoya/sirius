class AddExGpuToPc < ActiveRecord::Migration[5.2]
  def change
    add_column :pcs, :ex_gpu, :boolean
  end
end
