class QuizStartSerializer < ActiveModel::Serializer
  attributes :title, :attempts, :creator, :creator_name

  def creator
    object.user.email
  end

  def creator_name
    object.user.name
  end
end
