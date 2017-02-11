class Questions::Match < Question
  belongs_to :quiz
  has_many :pairs, inverse_of: :question, as: :question
  accepts_nested_attributes_for :pairs
end
