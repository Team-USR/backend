class Questions::ClozeSerializer < ActiveModel::Serializer
  attributes :id, :question, :type, :points
  attribute :sentence, if: -> { scope != "edit" }
  has_one :cloze_sentence, if: -> { scope == "edit" }
  has_one :gaps, if: -> { scope == "edit" }

  def sentence
    object.cloze_sentence.text
  end

  def type
    "cloze"
  end
end
