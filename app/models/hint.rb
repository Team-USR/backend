class Hint < ApplicationRecord
  belongs_to :gap
  validates_presence_of :hint_text
end
