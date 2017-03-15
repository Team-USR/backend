class QuizSerializer < ActiveModel::Serializer
  attributes :id, :title, :creator, :published, :attempts
  has_many :questions

  def creator
    object.user.email
  end
end
