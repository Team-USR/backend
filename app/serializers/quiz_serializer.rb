class QuizSerializer < ActiveModel::Serializer
  attributes :id, :title, :creator, :published, :attempts, :release_date
  has_many :questions

  def creator
    object.user.name
  end
end
