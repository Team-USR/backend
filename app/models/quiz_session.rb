class QuizSession < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  validates_presence_of :state
end
