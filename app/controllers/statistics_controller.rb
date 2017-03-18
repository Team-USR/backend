class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def average_marks_groups
    groups = current_user
      .groups_users
      .where(role: "admin")
      .map { |e| Group.find(e.group_id) }
    points = []
    groups.each do |g|
      quizzes = g.quizzes
      quizzes.each do |q|
        points << q.quiz_sessions.where(state: "submitted").map(&:score).sum / q.quiz_sessions.where(state: "submitted").size
      end
    end
    render json: {
      points: points
    }
  end
end
