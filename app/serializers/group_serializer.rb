class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :admins
  attribute :students, if: -> { scope == "edit" }
  attribute :pending_invites, if: -> { scope == "edit" }

  def admins
    object.admins.map(&:email)
  end

  def students
    object.students.map(&:email)
  end

  def pending_invites
    GroupInvite.where(group_id: object.id).map(&:email)
  end
end
