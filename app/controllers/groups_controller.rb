class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    render json: Group.all
  end

  def show
    render json: Group.find(params.require(:id))
  end

  def create
    @group = Group.new(params[:group])
    @group.groups_users.build(user_id: current_user.id, role: "admin")
    if @group.save
      render json: @group, status: :created
    else
      render_activemodel_validations(@group.errors)
    end
  end

  def add
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @user = User.find(params[:user_id])
    @group_user = GroupsUser.new(group_id: @group.id, user_id: @user.id)

    if @group_user.save
      render json: @group_user, status: :created
    else
      render_activemodel_validations(@group_user.errors)
    end
  end

  def delete
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @user_group = GroupsUser.find_by!(group_id: params[:id], user_id: params[:user_id])
    @group.users.delete(@user_group.user)
  end

  def users_update
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @admin = @group.admins.map { |user| user.id}
    @users_params = params[:users] + @admin
    @users = @users_params.map { |id| User.find(id) }.uniq
    @group.update!(users: @users)
    @group.save!
    head :ok
  end

  def destroy
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @group.destroy!
    head :ok
  end

  def quizzes
    @group = Group.find(params[:id])
    authorize! :manage, @group
    render json: @group.quizzes, each_serializer: QuizIndexSerializer
  end

  def quizzes_update
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @quizzes = params.require(:quizzes).map { |id| Quiz.find(id) }.uniq
    @group.update!(quizzes: @quizzes)
    head :ok
  end

  def students
    @group = Group.find(params[:id])
    authorize! :manage, @group
    render json: @group.students, each_serializer: UserGetSerializer
  end
end
