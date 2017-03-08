class Users::MineController < ApplicationController
  before_action :authenticate_user!, only: [:groups]

  def groups
    render json: Group.where(user_id: current_user.id)
    #render json: Group.where(user_id: 1)
  end
end
