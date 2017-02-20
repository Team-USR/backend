class Questions::Cloze < Question
  belongs_to :quiz
  has_many :gaps, inverse_of: :question, as: :question
  accepts_nested_attributes_for :gaps

  def gap_order
    gaps.map(&:gap_text).join(",")
  end

  def check(question_params)
    {
     correct: question_params[:answer] == gap_order,
     correct_gaps: gaps.map(&:gap_text)
   }
  end

end
