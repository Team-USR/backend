class Quiz < ApplicationRecord
  has_many :questions
  accepts_nested_attributes_for :questions

  validates_presence_of :title
end
