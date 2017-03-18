class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def average_marks_groups
    averages = current_user
    .groups_users
    .where(role: "admin")
    .map { |g_u| Group.find(g_u.group_id) }
    .map { |g| { group_id: g.id, group_name: g.name, average: g.quizzes_average } }
    render json: averages
  end

  private

  def to_reject(quizzes)
    quizzes.reject { |q| !q.quiz_sessions.where(state: "submitted").map(&:score).size.zero? }
  end
end
