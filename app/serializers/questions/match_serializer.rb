class Questions::MatchSerializer < ActiveModel::Serializer
  attributes :id, :question, :type, :points, :match_default
  attribute :left, if: -> { scope != "edit" }
  attribute :right, if: -> { scope != "edit" }
  has_many :pairs, if: -> { scope == "edit" }

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

  def match_default
    object.match_default.try!(:default_text)
  end
end
