class Question < ApplicationRecord
  belongs_to :quiz
  validates_presence_of :question

  def self.type_from_api(type_from_api)
    {
      "match" => "Questions::Match",
      "single_choice" => "Questions::SingleChoice"
    }[type_from_api]
  end
end
