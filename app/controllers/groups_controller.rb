class GroupsController < ApplicationController
  def index
    render json:Group.all
  end

  def show
    render json: Group.find(params.require(:id))
  end

  def create
    puts params
    @group = Group.new(params[:group])

    if @group.save
      render json: @group, status: :created_at
    else
      render_activemodel_validations(@group.errors)
    end
  end

  def add
    @group = Group.find_by(id: params[:id])
    @user = User.find_by(id: params[:user_id])

    if @group && @user
      @group.users << @user
      render json: { success: "true" }
    elsif @group.nil?
      render_error(
        :not_found,
        "not_found",
        "Couldn't find group with id #{params[:id]}"
      )
    elsif @user.nil?
      render_error(
        :not_found,
        "not_found",
        "Couldn't find user with id #{params[:user_id]}"
      )
    end
  end

  def delete
    UserGroup.find_by(group_id: params[:group_id], user_id: params[:user_id]).destroy
    render json: UserGroup.count
  end

end
