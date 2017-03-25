class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def average_marks_groups
    averages = current_user.groups_users.admin.
      left_outer_joins(group: [quizzes: [:quiz_sessions]]).
      group("groups.id").
      group("groups.name").
      average("quiz_sessions.score").
      map do |sql_result|
        {
          group_id: sql_result[0][0],
          group_name: sql_result[0][1],
          average: sql_result[1]
        }
      end
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
