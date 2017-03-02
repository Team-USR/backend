class QuizSessionSerializer < ActiveModel::Serializer
  attributes :quiz_id, :user_id, :state, :metadata
end
