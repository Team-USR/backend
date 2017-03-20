class Questions::MultipleChoice < Question
  belongs_to :quiz

  has_many :answers, inverse_of: :question, as: :question, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  validate :has_at_least_one_correct_answer

  def correct_answers
    answers.where(is_correct: true)
  end

  def save_format_correct?(save_params)
    return false if !save_params[:answer_ids].is_a?(Array)
    save_params[:answer_ids]
      .all? { |answer_id| Answer.find_by(id: answer_id, question_id: id).present? }
  end

  def check(question_params)
    answers_submitted = question_params[:answer_ids]
      .map { |answer_id| Answer.find_by(id: answer_id, question_id: id) }
      .compact
    pts = 0
    nr_of_correct_answers = answers_submitted.reject { |a| !correct_answers.include? a}.size
    if(nr_of_correct_answers.zero?)
      pts -= self.points
    else
      pts = self.points / correct_answers.size * nr_of_correct_answers
    end
    {
      correct: answers_submitted.map(&:id).sort == correct_answers.map(&:id).sort,
      points: pts,
      correct_answers: correct_answers.map(&:id).sort
    }
  end

  def has_at_least_one_correct_answer
    if answers.any? && answers.select { |a| a.is_correct }.empty?
      errors.add(:answers, "doesn't have any correct answers")
    end
  end
end
