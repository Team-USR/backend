class CreateAnswerModel < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.timestamps
      t.string :answer, null: false
      t.belongs_to :question, null: false
      t.boolean :is_correct, null: false
    end
  end
end
