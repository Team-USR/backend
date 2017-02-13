class Questions::MultipleChoiceSerializer < ActiveModel::Serializer
  attributes :id, :question, :type
  has_many :answers

  def type
    "multiple_choice"
  end
end
