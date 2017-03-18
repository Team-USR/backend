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

    @users = []

    # We can't remove admins
    @user_emails = params[:users]

    @users_status = @user_emails.map do |user_email|
      if user = User.find_by_email(user_email)
        @users << user
        {
          email: user_email,
          status: "added"
        }
      else
        GroupInviteJob.perform_later(group: @group, email: user_email)
        {
          email: user_email,
          status: "invited_to_join"
        }
      end
    end

    @group.update!(users: (@users + @group.admins))

    render json: @users_status, status: :ok
  end

  def destroy
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @group.destroy!
    head :ok
  end

  def quizzes
    @group = Group.find(params[:id])
    authorize! :display, @group
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
