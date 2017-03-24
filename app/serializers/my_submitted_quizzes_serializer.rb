class MySubmittedQuizzesSerializer < ActiveModel::Serializer
  attribute :quiz_name, :score

  def quiz_name
    Quiz.find(id: object.quiz_id).title
  end
end
