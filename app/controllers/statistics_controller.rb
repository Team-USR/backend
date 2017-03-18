class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def average_marks_groups
    GroupsUser.where(user: current_user, role: "admin")
  end
end
