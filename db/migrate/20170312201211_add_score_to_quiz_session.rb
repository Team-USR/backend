class AddScoreToQuizSession < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_sessions, :score, :float, default: nil
  end
end
