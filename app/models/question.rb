class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, inverse_of: :question
  accepts_nested_attributes_for :answers

  validates_presence_of :question

  def check_answer(answer_id)
    answer = Answer.find(answer_id)
    return false if answer.question_id != self.id
    answer.is_correct
  end
end
