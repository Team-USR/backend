class StatisticsController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    formats ['json']
    error 401, "Need to be logged in"
  end

  api :GET, "/statistics/average_marks_groups", "Returns the average marks for each group the user is in"
  description <<-EOS
    The request returns for each group an average of the marks for all the quizzes in that group.
    This resource is usable in teacher mode.
  EOS
  example <<-EOS
  [
    {
      "group_id": 1,
      "group_name": "My first group",
      "average": 5.5
    },
    {
      "group_id": 2,
      "group_name": "My second group",
      "average": 3
    }
  ]
  EOS
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

  api :GET, "/statistics/marks_groups_quizzes", "Returns the marks for each attempt that a user submitted for a specific quiz"
  description <<-EOS
    Returns the marks for each attempt that a user submitted for a specific quiz and return this data
    grouped by the groups that the user is in. If there is no attempt for a quiz , this will return for the marks field a null value.
    The resource is usable in student mode.
  EOS
  example <<-EOS
  [
  {
    "group_id": 4,
    "group_name": "test-group",
    "marks": null
  },
  {
    "group_id": 9,
    "group_name": "test-group 3",
    "marks": null
  },
  {
    "group_id": 10,
    "group_name": "testing groups",
    "marks": {
      "13": [
        {
          "quiz_id": 13,
          "quiz_title": "Title",
          "score": 1
        }
      ]
    }
  }
]
  EOS
  def marks_groups_quizzes
    marks = current_user
    .groups_users
    .where(role: "student")
    .map { |g_u| Group.find(g_u.group_id) }
    .map { |g| { group_id: g.id, group_name: g.name, marks: g.quizzes_marks } }
    render json: marks
  end
end
