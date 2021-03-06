class Group < ApplicationRecord
  has_many :groups_users, dependent: :delete_all
  has_many :users, through: :groups_users

  has_many :groups_users_student, -> { student }, dependent: :delete_all, class_name: GroupsUser
  has_many :students, through: :groups_users_student, source: :user

  has_many :groups_users_admin, -> { admin }, dependent: :delete_all, class_name: GroupsUser
  has_many :admins, through: :groups_users_admin, source: :user, class_name: User

  has_many :groups_quizzes, dependent: :delete_all
  has_many :quizzes, -> { distinct }, through: :groups_quizzes

  has_many :pending_invites, class_name: GroupInvite
  has_many :pending_requests, class_name: GroupJoinRequest
  has_many :pending_requests_users, through: :pending_requests, source: :user

  belongs_to :user
  validates_presence_of :name

  def pending_invite_users
    pending_invites.map(&:email)
  end
end
