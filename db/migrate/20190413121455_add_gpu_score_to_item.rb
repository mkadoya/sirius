class AddGpuScoreToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :gpu_score, :integer
  end
end
