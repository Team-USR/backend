class Questions::MixSerializer < ActiveModel::Serializer
  attributes :id, :question, :type
  has_many :words

  def type
    "multiple_choice"
  end

  # def words
  #   
  # end
end
