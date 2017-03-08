class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :creator

  def creator
    object.user.email
  end
end
