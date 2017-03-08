class GroupsController < ApplicationController
  #before_action :authenticate_user!, only: [:create]
  def index
    render json: Group.all
  end

  def show
    render json: Group.find(params.require(:id))
  end

  def create
    #@group = Group.new(params[:group].merge(user_id: current_user.id))
    @group = Group.new(params[:group].merge(user_id: 1))
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

  def quizzes
    @group_quiz = Group.find(params[:id])
    render json: @group_quiz.quizzes, each_serializer: QuizIndexSerializer
  end

  def quizzes_update
    @group = Group.find(params[:id])
    @quizzes = params[:quizzes].map { |id| Quiz.find(id) }.uniq
    @group.update!(quizzes: @quizzes)
    head :ok
  end
end
