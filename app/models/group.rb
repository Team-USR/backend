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

  def quizzes_average
    quiz_sessions = quizzes
      .flat_map { |q| q.quiz_sessions.where(state: "submitted") }
    if quiz_sessions.any?
      quiz_sessions.sum(&:score).to_f / quiz_sessions.size.to_f
    else
      nil
    end
  end

  def quizzes_marks
    quiz_sessions = quizzes
      .flat_map { |q| q.quiz_sessions.where(state: "submitted") }
      .map { |q| { quiz_id: q.quiz_id, quiz_title: Quiz.where(id: q.quiz_id).first.title, score: q.score } }
      .group_by { |q| q[:quiz_id] }
    if quiz_sessions.any?
      quiz_sessions
    else
      nil
    end
  end
end
