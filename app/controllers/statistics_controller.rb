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

  def marks_groups_quizzes
    marks = current_user
    .groups_users
    .where(role: "student")
    .map { |g_u| Group.find(g_u.group_id) }
    .map { |g| { group_id: g.id, group_name: g.name, marks: g.quizzes_marks } }
    render json: marks
  end
end
