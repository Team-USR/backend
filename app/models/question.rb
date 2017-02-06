class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, inverse_of: :question
  accepts_nested_attributes_for :answers

  validates_presence_of :question

  def check_answer(answer_id)
    answers.where(is_correct: true).first.id == answer_id
  end
end
