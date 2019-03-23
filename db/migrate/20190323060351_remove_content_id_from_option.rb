class RemoveContentIdFromOption < ActiveRecord::Migration[5.2]
  def change
    remove_column :options, :content, :text
  end
end
