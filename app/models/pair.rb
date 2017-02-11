class Pair < ApplicationRecord
  belongs_to :question, polymorphic: true

  has_one :left_choice, class_name: "PairChoice"
  has_one :right_choice, class_name: "PairChoice"

  accepts_nested_attributes_for :left_choice, :right_choice
end
