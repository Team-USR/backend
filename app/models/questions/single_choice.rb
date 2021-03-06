class Questions::SingleChoice < Question
  belongs_to :quiz
  has_many :answers, inverse_of: :question, as: :question, dependent: :destroy
  validates :answers, length: { minimum: 1 }
  accepts_nested_attributes_for :answers, allow_destroy: true
  validate :has_only_one_correct_answer

  def check(question_params, negative_marking)
    answer = Answer.find_by(id: question_params[:answer_id], question_id: id)
    pts = 0
    if answer == correct_answer
      pts = points
    elsif negative_marking == true
      pts -= points
    end
    {
      correct: answer == correct_answer,
      points: pts,
      correct_answer: correct_answer.id
    }
  end

  def save_format_correct?(save_params)
    Answer.find_by(id: save_params[:answer_id], question_id: id).present?
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
