class Questions::Cloze < Question
  belongs_to :quiz
  has_many :gaps, inverse_of: :question, as: :question
  has_one :cloze_sentence, inverse_of: :question, as: :question
  accepts_nested_attributes_for :gaps, :cloze_sentence

  def gap_order
    gaps.map(&:gap_text).join(",")
  end

  def check(question_params)
    {
     correct: question_params[:answer_gaps].join(",") == gap_order,
     correct_gaps: gaps.map(&:gap_text)
   }
  end

  def answer_params
    "answer_gaps"
  end
end
