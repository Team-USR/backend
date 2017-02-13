class Questions::Mix < Question
  belongs to :quiz
  has_one :mix_pair, inverse_of: :question, as: :question
  accepts_nested_attributes_for :mix_pair
end
