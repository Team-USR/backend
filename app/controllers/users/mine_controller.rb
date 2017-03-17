class Users::MineController < ApplicationController
  before_action :authenticate_user!, only: [:groups, :quizzes]

  def groups
    render json: current_user.groups_users
  end

  def quizzes
    render json: current_user.groups
    .reject{ |group_admined_by| group_admined_by.admins.include? current_user }
    .flat_map(&:quizzes)
    .reject{ |quiz| quiz.published == false }
    .reject{ |quiz| quiz.release_date < Date.today }, each_serializer: MyQuizzesSerializer
  end
end
