class GroupsController < ApplicationController
  def index
    render json:Group.all
  end

  def show
    render json: Group.find(params.require(:id))
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      render json: @group, status: :created_at
    else
      render_activemodel_validations(@group.errors)
    end
  end

  def add
    UserGroup.find_or_create_by(group_id: params[:group_id], user_id: params[:user_id])
    render json: UserGroup.count
  end

  def delete
    UserGroup.find_by(group_id: params[:group_id], user_id: params[:user_id]).destroy
    render json: UserGroup.count
  end

end
