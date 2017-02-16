class Questions::SingleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question
  accepts_nested_attributes_for :answers

  def check(question_params)
    answer = Answer.find_by(id: question_params[:answer_id], question_id: id)
    {
      correct: answer == correct_answer,
      correct_answer: correct_answer.id
    }
  end

  private

  def correct_answer
    answers.find_by(is_correct: true)
  end
end
