class AddAttemptsToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :attempts, :integer, default: 0, null: false
  end
end
