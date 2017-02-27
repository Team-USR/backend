class QuizSerializer < ActiveModel::Serializer
  attributes :id, :title
  # :creator
  has_many :questions

  # def creator
  #   object.user.email
  # end
end
