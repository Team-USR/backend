class PairSerializer < ActiveModel::Serializer
  attribute :left_choice_id, if: -> { scope != "edit" }
  attribute :right_choice_id, if: -> { scope != "edit" }
  attribute :left_choice, if: -> { scope == "edit" }
  attribute :right_choice, if: -> { scope == "edit" }
  attribute :id, if: -> { scope == "edit" }

  def left_choice_id
    object.left_choice_uuid
  end

  def right_choice_id
    object.right_choice_uuid
  end
end
