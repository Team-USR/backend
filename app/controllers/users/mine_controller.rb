class Users::MineController < ApplicationController
  before_action :authenticate_user!, only: [:groups]

  def groups
    render json: current_user.groups
  end
end
