class CrossMetadata < ApplicationRecord
  belongs_to :question
  validates_presence_of :height, :width
end
