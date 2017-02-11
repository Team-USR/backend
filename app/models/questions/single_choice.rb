class Questions::SingleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question
  accepts_nested_attributes_for :answers

  def check_answer(answer_id)
    answer = Answer.find_by(id: answer_id)
    return false if answer.nil? || answer.question_id != id
    answer.is_correct
  end
end
