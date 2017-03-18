class QuizSessionSerializer < ActiveModel::Serializer
  attributes :state, :last_updated, :metadata
  attribute :score, if: -> { object.state == "submitted" }

  def last_updated
    object.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p")
  end
end
