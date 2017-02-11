class Questions::MatchSerializer < ActiveModel::Serializer
  attributes :id, :question, :left, :right, :type

  def left
    object.pairs.map do |pair|
      {
        id: pair.left_choice_uuid,
        answer: pair.left_choice
      }
    end.shuffle
  end

  def right
    object.pairs.map do |pair|
      {
        id: pair.right_choice_uuid,
        answer: pair.right_choice
      }
    end.shuffle
  end

  def type
    "match"
  end
end
