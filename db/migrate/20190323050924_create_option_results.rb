class CreateOptionResults < ActiveRecord::Migration[5.2]
  def change
    create_table :option_results do |t|
      t.integer :user_id
      t.string :category
      t.integer :question_id
      t.integer :option_num
      t.boolean :result

      t.timestamps
    end
  end
end
