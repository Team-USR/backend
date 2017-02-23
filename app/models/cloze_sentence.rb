class ClozeSentence < ApplicationRecord
  belongs_to :question, inverse_of: :cloze_sentence, polymorphic: true
end
