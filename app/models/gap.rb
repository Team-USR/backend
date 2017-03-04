class Gap < ApplicationRecord
  belongs_to :question, polymorphic: true
  validates_presence_of :gap_text
  has_one :hint, dependent: :destroy

  accepts_nested_attributes_for :hint, allow_destroy: true
end
