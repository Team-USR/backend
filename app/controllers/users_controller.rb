class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render_activemodel_validations(@user.errors)
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    authorize! :manage, @user

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
