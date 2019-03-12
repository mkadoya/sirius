class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :category
      t.text :content
      t.boolean :option
      t.integer :option_id

      t.timestamps
    end
  end
end
