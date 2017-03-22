class Questions::Cloze < Question
  belongs_to :quiz
  has_many :gaps, inverse_of: :question, as: :question, dependent: :destroy
  has_one :cloze_sentence, inverse_of: :question, as: :question, dependent: :destroy
  accepts_nested_attributes_for :gaps, :cloze_sentence, allow_destroy: true

  def gap_order
    gaps.map(&:gap_text).join(",")
  end

  def check(question_params)
    {
     correct: question_params[:answer_gaps].join(",") == gap_order,
     correct_gaps: gaps.map(&:gap_text)
   }
  end

  def save_format_correct?(save_params)
    return false if !save_params[:answer_gaps].is_a?(Array)
    save_params[:answer_gaps].all? { |gap| gap.is_a?(String) }
  end
end
