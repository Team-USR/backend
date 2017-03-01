class Questions::SingleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question
  accepts_nested_attributes_for :answers
  validate :has_only_one_correct_answer

  def check(question_params)
    answer = Answer.find_by(id: question_params[:answer_id], question_id: id)
    {
      correct: answer == correct_answer,
      correct_answer: correct_answer.id
    }
  end

  def answer_params
    "answer_id"
  end

  private

  def correct_answer
    answers.find_by(is_correct: true)
  end

  def has_only_one_correct_answer
    if answers.select { |a| a.is_correct }.count > 1
      errors.add(:answers, "have multiple correct answers, but this is a single choice question")
    end

    if answers.any? && answers.select { |a| a.is_correct }.empty?
      errors.add(:answers, "doesn't have any correct answers")
    end
  end
end
