class AddNegativeMarkingToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :negative_marking, :boolean, default: false
  end
end
