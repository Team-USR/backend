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
    marks = current_user.groups_users.student.
      left_outer_joins(group: [quizzes: [:quiz_sessions]]).
      where(group_id: params.require(:id)).
      group("groups.id").
      group("groups.name").
      group("quizzes.title").
      maximum("quiz_sessions.score").
      map do |sql_result|
        {
          group_id: sql_result[0][0],
          group_name: sql_result[0][1],
          marks:
          {
            quiz_name: sql_result[0][2],
            score: sql_result[1]
          }
        }
      end
    render json: marks
  end
end
