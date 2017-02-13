class MixPair < ApplicationRecord
  #serialize :alternate_sentence
  belongs_to :question, polymorphic: true

  validates_presence_of :main_sentence , :alternate_sentences
end
