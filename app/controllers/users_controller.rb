class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_unity
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
