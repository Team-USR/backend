class GroupsController < ApplicationController
  def index
    render json: Group.all
  end

  def show
    render json: Group.find(params.require(:id))
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      render json: @group, status: :created
    else
      render_activemodel_validations(@group.errors)
    end
  end

  def add
    @group = Group.find_by(id: params[:id])
    @user = User.find_by(id: params[:user_id])

    if @group && @user
      @group_user = GroupsUser.new(group_id: @group.id, user_id: @user.id)
      if @group_user.save
        render json: @group_user, status: :created
      else
        render_activemodel_validations(@group_user.errors)
      end
    elsif @group.nil?
      render_error(
        status: :not_found,
        code: "not_found",
        detail: "Couldn't find group with id #{params[:id]}"
      )
    elsif @user.nil?
      render_error(
        status: :not_found,
        code: "not_found",
        detail: "Couldn't find user with id #{params[:user_id]}"
      )
    end
  end

  def delete
    @user_group = GroupsUser.find_by(group_id: params[:id], user_id: params[:user_id])
    if @user_group.nil?
      render_error(
        status: :not_found,
        code: "not_found",
        detail: "Couldn't find user and group association with user_id #{params[:user_id]} group_id #{params[:id]}"
      )
    else
      @user_group.group.users.delete(@user_group.user)
      render json: { "success": true }
    end
  end
end
