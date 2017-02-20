class Role < ApplicationRecord
  has_many :assignments
  has_and_belongs_to_many :users
end
