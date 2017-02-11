class CreateBaseTables < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    create_table :quizzes do |t|
      t.timestamps

      t.string :title, null: false
    end

    create_table :questions do |t|
      t.timestamps
      t.string :question, null: false
      t.belongs_to :quiz
    end

    create_table :answers do |t|
      t.timestamps
      t.string :answer, null: false
      t.references :question, polymorphic: true, index: true, null: false
      t.boolean :is_correct, null: false
    end
  end
end
