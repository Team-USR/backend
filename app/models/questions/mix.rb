class Questions::Mix < Question
  belongs to :quiz
  has_many :sentences, inverse_of: :question, as: :question
  accepts_nested_attributes_for :sentences
end
