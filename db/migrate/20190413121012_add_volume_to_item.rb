class AddVolumeToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :volume, :integer
  end
end
