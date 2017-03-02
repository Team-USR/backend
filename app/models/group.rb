class Group < ApplicationRecord
  has_many :groups_users
  has_many :users, -> { distinct }, through: :groups_users
  has_many :quizzes,  -> { distinct }, through: :groups_quizzes
  has_many :groups_quizzes
  validates_presence_of :name
end
