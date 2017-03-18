class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def average_marks_groups
    groups = current_user
      .groups_users
      .where(role: "admin")
      .map { |e| Group.find(e.group_id) }
    points = []
    groups.each do |g|
      points << g.quizzes
                .sessions.where(state: "submitted")
                .average(&:points)
    end
    render json: {
      points: points
    }
  end
end
