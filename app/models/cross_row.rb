class CrossRow < ApplicationRecord
  belongs_to :question
  validates_presence_of :row

  validates_format_of :row, with: /\A(\*|[a-z])+\z/
end
