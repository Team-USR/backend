class Question < ApplicationRecord
  belongs_to :quiz, inverse_of: :questions
  validates_presence_of :question, :type

  def self.type_from_api(type_from_api)
    {
      "match" => "Questions::Match",
      "single_choice" => "Questions::SingleChoice",
      "multiple_choice" => "Questions::MultipleChoice",
      "mix" => "Questions::Mix",
      "cloze" => "Questions::Cloze",
      "cross" => "Questions::Cross"
    }[type_from_api]
  end

end
