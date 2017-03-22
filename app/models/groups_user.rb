class GroupsUser < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user_id, scope: :group_id

  scope :admin, -> { where(role: "admin") }
  scope :student, -> { where(role: "student") }
end
