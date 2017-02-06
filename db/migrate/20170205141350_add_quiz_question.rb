class AddQuizQuestion < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.timestamps

      t.string :title, null: false
    end
  end
end
