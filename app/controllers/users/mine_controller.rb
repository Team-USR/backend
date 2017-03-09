class Users::MineController < ApplicationController
  before_action :authenticate_user!, only: [:groups]

  def groups
    render json: Group.where(user_id: current_user.id)
  end

  def groups_in
    render json: current_user.groups_in
  end
end
