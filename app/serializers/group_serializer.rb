class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :admins
  has_many :students
  attribute :pending_invite_users, if: -> { scope == "edit" }
  has_many :pending_requests_users, if: -> { scope == "edit" }
end
