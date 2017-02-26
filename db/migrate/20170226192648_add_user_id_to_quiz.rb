class AddUserIdToQuiz < ActiveRecord::Migration[5.0]
  def change
    add_reference :quizzes, :user
    add_foreign_key :quizzes, :users
  end
end
