class Questions::MultipleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question
  accepts_nested_attributes_for :answers

  def correct_answers
    answers.where(is_correct: true)
  end
end
