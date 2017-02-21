class Sentence < ApplicationRecord
  belongs_to :question, polymorphic: true
  validates_presence_of :text
  validates :is_main, inclusion: [true, false]
end
