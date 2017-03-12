class QuizSession < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  validates_presence_of :state
  validate :number_of_attempts

  def number_of_attempts
    if quiz.attempts.zero?
      errors.add(:no_attempts, "You don't have any attempts left!")
      false
    end
    true
  end
end
