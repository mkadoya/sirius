class AddMicrosoftofficeToPc < ActiveRecord::Migration[5.2]
  def change
    add_column :pcs, :microsoftoffice, :boolean
  end
end
