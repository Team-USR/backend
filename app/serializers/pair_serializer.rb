class PairSerializer < ActiveModel::Serializer
  attributes :left_choice_id, :right_choice_id

  def left_choice_id
    object.left_choice_uuid
  end

  def right_choice_id
    object.right_choice_uuid
  end
end
