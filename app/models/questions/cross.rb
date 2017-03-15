class Questions::Cross < Question
  belongs_to :quiz
  has_one :metadata, class_name: CrossMetadata, inverse_of: :question, as: :question
  has_many :rows, -> { order(:created_at) }, class_name: CrossRow, inverse_of: :question, as: :question
  has_many :hints, class_name: CrossHint, inverse_of: :question, as: :question

  accepts_nested_attributes_for :metadata, :rows, :hints

  def check(question_params)
    {
     correct: question_params[:rows] == rows.map(&:row),
     correct_rows: rows.map(&:row)
   }
  end

  def save_format_correct?(save_params)
    save_params[:rows].is_a?(Array)
  end
end
