class CreatePatterns < ActiveRecord::Migration[5.2]
  def change
    create_table :patterns do |t|
      t.string :category
      t.integer :pattern_id
      t.boolean :answer_1
      t.boolean :answer_2
      t.boolean :answer_3
      t.boolean :answer_4
      t.boolean :answer_5
      t.boolean :answer_6
      t.boolean :answer_7
      t.boolean :answer_8
      t.boolean :answer_9
      t.boolean :answer_10
      t.boolean :answer_11
      t.boolean :answer_12

      t.timestamps
    end
  end
end
