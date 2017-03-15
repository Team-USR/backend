class Users::MineController < ApplicationController
  before_action :authenticate_user!, only: [:groups, :quizzes]

  def groups
    render json: current_user.groups_users
  end

  def quizzes
    render json: current_user.groups.flat_map(&:quizzes), each_serializer: MyQuizzesSerializer
  end
end
