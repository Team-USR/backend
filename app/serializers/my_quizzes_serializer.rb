class MyQuizzesSerializer < ActiveModel::Serializer
  attributes :id, :title, :status

  def status
    session = QuizSession.where(quiz: Quiz.where(id: object.id), user: current_user).last
    if !session.nil?
      session.state
    else
      "not_started"
    end
  end
end
