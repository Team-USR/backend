class Questions::MixSerializer < ActiveModel::Serializer
  attributes :id, :question, :type
  has_many :words

  def type
    "mix"
  end
end
