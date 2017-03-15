class CrossHint < ApplicationRecord
  belongs_to :question
  validates_presence_of :hint, :row, :column

  validates :across, inclusion: [true, false]
end
