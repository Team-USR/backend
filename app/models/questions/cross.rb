class Questions::Cross < Question
  belongs_to :quiz
  has_one :metadata, class_name: CrossMetadata, inverse_of: :question, as: :question
  has_many :rows, -> { order(:created_at) }, class_name: CrossRow, inverse_of: :question, as: :question
  has_many :hints, class_name: CrossHint, inverse_of: :question, as: :question

  accepts_nested_attributes_for :metadata, :rows, :hints

  def check(question_params)
    result = question_params[:rows] == rows.map(&:row)
    pts = 0
    if result == true
      pts = points
    else
      pts = -points
    end
    {
     correct: question_params[:rows] == rows.map(&:row),
     points: pts,
     correct_rows: rows.map(&:row)
   }
  end

  def save_format_correct?(save_params)
    save_params[:rows].is_a?(Array)
  end
end
