class CreateQuestion < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.timestamps
      t.string :question, null: false
      t.belongs_to :quiz
    end
  end
end
