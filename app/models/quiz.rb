class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true
  has_many :groups, -> { distinct }, through: :groups_quizzes
  has_many :groups_quizzes

  belongs_to :user

  validates_presence_of :title, :user

  def questions_attributes=(attr)
    self.questions = []
    super
  end
end
