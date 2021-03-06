class Questions::MixSerializer < ActiveModel::Serializer
  attributes :id, :question, :type, :points
  has_many :words, if: -> { scope != "edit" }
  has_many :sentences, if: -> { scope == "edit" }

  def type
    "mix"
  end
end
