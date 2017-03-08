class AddPublishToQuiz < ActiveRecord::Migration[5.0]
  def change
    if !column_exists?(:quizzes, :published)
      add_column :quizzes, :published, :boolean, default: false, null: false
    end
  end
end
