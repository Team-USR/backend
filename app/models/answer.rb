class Answer < ApplicationRecord
  belongs_to :question, polymorphic: true

  validates_presence_of :answer
  validates :is_correct, inclusion: [true, false]
end
