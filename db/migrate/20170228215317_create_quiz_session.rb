class CreateQuizSession < ActiveRecord::Migration[5.0]
  def change
    create_table :quiz_sessions do |t|
      t.timestamps
      t.belongs_to :user
      t.belongs_to :quiz
      t.string :state, null: false, default: "in_progress"
      t.jsonb :metadata
    end
  end
end
