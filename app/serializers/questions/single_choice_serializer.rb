class Questions::SingleChoiceSerializer < ActiveModel::Serializer
  attributes :id, :question, :type
  has_many :answers

  def type
    "single_choice"
  end
end
