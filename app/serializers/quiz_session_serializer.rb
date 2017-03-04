class QuizSessionSerializer < ActiveModel::Serializer
  attributes :user_id, :quiz_id, :state, :metadata
end
