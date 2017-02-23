class GroupsUser < ApplicationRecord
  belongs_to :user
  belongs_to :groups

  validates_uniqueness_of :user_id, scope: :group_id
end
