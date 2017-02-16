class Sentence < ApplicationRecord
  belongs_to :question, polymorphic: true
  validates_presence_of :text
end
