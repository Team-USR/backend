class Questions::ClozeSerializer < ActiveModel::Serializer
  attributes :id, :question, :type, :points
  attribute :sentence, if: -> { scope != "edit" }
  has_one :cloze_sentence, if: -> { scope == "edit" }
  has_one :gaps, if: -> { scope == "edit" }
  attribute :hints, if: -> { scope != "edit" }

  def sentence
    object.cloze_sentence.text
  end

  def type
    "cloze"
  end

  def hints
    object.gaps.map { |gap| gap.hint.try(:hint_text) }
  end
end
