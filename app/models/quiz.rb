class Quiz < ApplicationRecord
  has_many :questions, inverse_of: :quiz
  accepts_nested_attributes_for :questions
end
