class Questions::Cloze < Question
  belongs_to :quiz
  has_many :gaps, -> { order(:created_at) }, inverse_of: :question, as: :question, dependent: :destroy
  has_one :cloze_sentence, inverse_of: :question, as: :question, dependent: :destroy, required: true
  accepts_nested_attributes_for :gaps, :cloze_sentence, allow_destroy: true

  def gap_order
    gaps.map(&:gap_text).join(",")
  end

  def check(question_params, negative_marking)
    pts = 0
    answers = question_params[:answer_gaps].zip(gap_order.split(",")).map { |a| a.first == a[1] }
    if !answers.count(true).zero?
      pts += points / answers.size * answers.count(true)
    elsif negative_marking
      pts = - points
    end
    {
     correct: question_params[:answer_gaps].join(",") == gap_order,
     points: pts,
     correct_gaps: gaps.map(&:gap_text)
   }
  end

  def save_format_correct?(save_params)
    return false if !save_params[:answer_gaps].is_a?(Array)
    save_params[:answer_gaps].all? { |gap| gap.is_a?(String) }
  end
end
