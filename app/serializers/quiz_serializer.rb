class QuizSerializer < ActiveModel::Serializer
  attributes :id, :title, :creator
  has_many :questions

  def creator
    object.user.email
  end

  # def groups
  #   result = []
  #   @options[:groups_attributes].each do |group_param|
  #     result << Group.find_by(id: group_param[:id])
  #   end
  # end
end
