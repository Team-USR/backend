class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers

  validates_presence_of :question

  def check_answer(answer_id)
    answers.where(is_correct: true).first.id == answer_id
  end
end
