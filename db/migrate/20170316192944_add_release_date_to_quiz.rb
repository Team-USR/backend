class AddReleaseDateToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :release_date, :date, default: nil
  end
end
