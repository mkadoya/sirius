class AddContentIdToOption < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :content, :text
  end
end
