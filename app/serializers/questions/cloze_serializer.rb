class Questions::ClozeSerializer < ActiveModel::Serializer
  attributes :id, :question, :type, :sentence

  def sentence
    object.cloze_sentence
  end
end
