class Questions::MatchSerializer < ActiveModel::Serializer
  attributes :id, :question, :left, :right, :type

  def left
    object.pairs.map do |pair|
      {
        id: pair.left_choice.uuid,
        test: pair.left_choice.title
      }
    end.shuffle
  end

  def right
    object.pairs.map do |pair|
      {
        id: pair.right_choice.uuid,
        test: pair.right_choice.title
      }
    end.shuffle
  end

  def type
    "match"
  end
end
