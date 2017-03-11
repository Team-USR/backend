class MyQuizzesSerializer < ActiveModel::Serializer
  attributes :id, :title, :status

  def status
    session = QuizSession.find_by(quiz: Quiz.where(id: object.id), user: current_user)
    if !session.nil?
      session.state
    else
      "not_started"
    end
  end
end
