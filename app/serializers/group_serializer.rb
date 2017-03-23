class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :admins, if: -> { scope == "edit" }
  has_many :students, if: -> { scope == "edit" }
  attribute :pending_invite_users, if: -> { scope == "edit" }
  has_many :pending_requests_users, if: -> { scope == "edit" }
end
