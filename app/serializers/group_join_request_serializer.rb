class GroupJoinRequestSerializer < ActiveModel::Serializer
  belongs_to :group
  attribute :requested_at

  def requested_at
    object.created_at.strftime("Requested on %m/%d/%Y at %I:%M%p")
  end
end
