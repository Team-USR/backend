class Quiz < ApplicationRecord
  has_many :questions
  accepts_nested_attributes_for :questions
  has_many :groups
  has_many :groups_quizzes

  belongs_to :user

  validates_presence_of :title, :user
end
