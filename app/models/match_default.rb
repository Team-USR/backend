class MatchDefault < ApplicationRecord
  belongs_to :question, inverse_of: :match_default, polymorphic: true
  validates_presence_of :default_text
end
