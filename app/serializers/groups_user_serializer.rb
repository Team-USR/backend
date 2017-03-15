class GroupsUserSerializer < ActiveModel::Serializer
  attributes :role, :id, :name, :admins

  def admins
    object.group.admins.map(&:email)
  end

  def id
    object.group.id
  end

  def name
    object.group.name
  end
end
