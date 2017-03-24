class QuizSessionSerializer < ActiveModel::Serializer
  attributes :state, :last_updated, :metadata, :quiz_title
  attribute :score, if: -> { object.state == "submitted" }

  def last_updated
    object.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p")
  end

  def quiz_title
    Quiz.where(id: object.quiz_id).first.title if Quiz.where(id: object.quiz_id).any?
  end
end
