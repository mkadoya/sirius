class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.integer :option_id
      t.string :category
      t.integer :question_id
      t.text :option1
      t.text :option2
      t.text :option3
      t.text :option4
      t.text :option5
      t.text :option6

      t.timestamps
    end
  end
end
