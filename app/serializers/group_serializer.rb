class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :admins

  def admins
    object.admins.map(&:email)
  end
end
