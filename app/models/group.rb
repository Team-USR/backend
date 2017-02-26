class Group < ApplicationRecord
  has_many :groups_users
  has_many :users, -> { distinct }, through: :groups_users

  validates_presence_of :name
end
