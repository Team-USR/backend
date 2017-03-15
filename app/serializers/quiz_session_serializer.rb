class QuizSessionSerializer < ActiveModel::Serializer
  attributes :state, :metadata
  attribute :score, if: -> { object.state == "submitted" }
end
