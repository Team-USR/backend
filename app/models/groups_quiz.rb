class GroupsQuiz < ApplicationRecord
  belongs_to :quiz
  belongs_to :group

  validates_uniqueness_of :quiz_id, scope: :group_id
end
