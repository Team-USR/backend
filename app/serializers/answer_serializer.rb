class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :answer
  attribute :is_correct, if: -> { scope == "edit" }
end
