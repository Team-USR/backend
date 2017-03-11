class Group < ApplicationRecord
  has_many :groups_users, dependent: :delete_all
  has_many :users, through: :groups_users
  has_many :quizzes,  -> { distinct }, through: :groups_quizzes
  has_many :groups_quizzes, dependent: :delete_all

  validates_presence_of :name

  def admins
    groups_users.includes(:user).where(role: "admin").map(&:user)
  end

  def students
    groups_users.includes(:user).where(role: "student").map(&:user)
  end
end
