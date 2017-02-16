class Questions::MultipleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question
  accepts_nested_attributes_for :answers

  def correct_answers
    answers.where(is_correct: true)
  end

  def check(question_params)
    answers_submitted = question_params[:answer_ids]
      .map { |answer_id| Answer.find_by(id: answer_id, question_id: id) }
      .compact
    {
      correct: answers_submitted.map(&:id).sort == correct_answers.map(&:id).sort,
      correct_answers: correct_answers.map(&:id).sort
    }
  end
end
