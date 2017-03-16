class QuizSessionStartSerializer < ActiveModel::Serializer
  attributes :state, :created_at, :last_updated
  attribute :score, if: -> { object.state == "submitted" }

  def created_at
    object.created_at.strftime("Created on %m/%d/%Y at %I:%M%p")
  end

  def last_updated
    object.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p")
  end
end
