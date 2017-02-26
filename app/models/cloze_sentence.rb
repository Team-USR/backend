class ClozeSentence < ApplicationRecord
  belongs_to :question, inverse_of: :cloze_sentence, polymorphic: true

  validates_presence_of :text
end
