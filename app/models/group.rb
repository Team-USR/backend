class Group < ApplicationRecord
  has_many :groups_users, dependent: :delete_all
  has_many :users, -> { distinct }, through: :groups_users
  has_many :quizzes,  -> { distinct }, through: :groups_quizzes
  has_many :groups_quizzes, dependent: :delete_all

  validates_presence_of :name, :user

  belongs_to :user
end
