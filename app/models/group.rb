class Group < ApplicationRecord
  has_many :groups_users, dependent: :delete_all
  has_many :users, through: :groups_users
  has_many :quizzes, -> { distinct }, through: :groups_quizzes
  has_many :groups_quizzes, dependent: :delete_all
  belongs_to :user
  validates_presence_of :name

  def admins
    groups_users.includes(:user).where(role: "admin").map(&:user)
  end

  def students
    groups_users.includes(:user).where(role: "student").map(&:user)
  end

  def quizzes_average
    quiz_sessions = quizzes
      .flat_map { |q| q.quiz_sessions.where(state: "submitted") }
    if quiz_sessions.any?
      quiz_sessions.sum(&:score) / quiz_sessions.size
    else
      nil
    end
  end

  def quizzes_marks
    quiz_sessions = quizzes
      .flat_map { |q| q.quiz_sessions.where(state: "submitted") }
      .map { |q| { quiz_id: q.quiz_id, score: q.score } }
      .group_by { |q| q[:quiz_id] }
    if quiz_sessions.any?
      quiz_sessions
    else
      nil
    end
  end
end
