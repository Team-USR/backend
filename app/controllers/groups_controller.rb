class GroupsController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    formats ['json']
    error 401, "Need to be logged in"
    error 401, "Unauthorized! Can't access resource"
  end

  api :GET, '/groups/:id/edit', "Return required attributes for editting a group"
  param :id, :number, required: true, desc: "ID of group"
  error 404, "Couldn't find group"
  def edit
    render json: GroupSerializer.new(Group.find(params[:id]), scope: "edit").as_json
  end

  api :POST, '/groups', "Creates a group attached to the logged in user"
  param :group, Hash, desc: "Details of group" do
    param :name, String, required: true, desc: "Name of group required"
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

  api :POST, '/groups/:id/add', "Adds an user to the group"
  param :id, :number, required: true, desc: "ID of group"
  param :user_id, :number, required: true, desc: "ID of user"
  error 404, "Couldn't find group"
  error 404, "Couldn't find user"
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

  api :DELETE, '/groups/:id/delete', "Removes an user from the group"
  param :id, :number, required: true, desc: "ID of group"
  param :user_id, :number, required: true, desc: "ID of user"
  error 404, "Couldn't find group"
  error 404, "User is not in the group"
  def delete
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @user_group = GroupsUser.find_by!(group_id: params[:id], user_id: params[:user_id])
    @group.users.delete(@user_group.user)
  end

  api :POST, '/groups/:id/users_update', "Updates (overrides) the users of the group"
  param :id, :number, required: true, desc: "ID of group"
  param :users, Array, of: String, required: true, desc: "List of emails"
  error 404, "Couldn't find group"
  example <<-EOS
    [
      {
        "email": "vlad@kcl.ac.uk",
        "status": "added"
      },
      {
        "email": "vlad@kcl.ac.uk",
        "status": "invited_to_join"
      },
    ]
  EOS
  description <<-EOS
    Overrides users with the users received (admins are kept and can't be removed).
    The response contains information about whether the user was added or invited
    to join application if they do not have an account
  EOS
  def users_update
    @group = Group.find(params[:id])
    authorize! :manage, @group

    @users = []

    @users_status = params.require(:users).map do |user_email|
      if user = User.find_by_email(user_email)
        @users << user
        {
          email: user_email,
          status: "added"
        }
      else
        GroupInviteJob.perform_later(@group, user_email)
        {
          email: user_email,
          status: "invited_to_join"
        }
      end
    end

    @group.update!(users: (@users + @group.admins))

    render json: @users_status, status: :ok
  end

  api :DELETE, '/groups/:id', "Deletes the group"
  param :id, :number, required: true, desc: "ID of group"
  error 404, "Couldn't find group"
  def destroy
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @group.destroy!
    head :ok
  end

  api :GET, '/groups/:id/quizzes', "Returns the quizzes from the group"
  param :id, :number, required: true, desc: "ID of group"
  error 404, "Couldn't find group"
  example <<-EOS
    [
      {
        "id": 1,
        "title": "Published Quiz",
        "published": true
      }
    ]
  EOS
  def quizzes
    @group = Group.find(params[:id])
    authorize! :display, @group
    render json: @group.quizzes, each_serializer: QuizIndexSerializer
  end

  api :POST, '/groups/:id/quizzes_update', "Updates (overrides) the quizzes of the group"
  param :id, :number, required: true, desc: "ID of group"
  param :quizzes, Array, of: Integer, required: true, desc: "List of quizzes by id"
  error 404, "Couldn't find group"
  error 404, "Couldn't find quiz"
  description <<-EOS
    Overrides users with the users received (admins are kept and can't be removed).
    The response contains information about whether the user was added or invited
    to join application if they do not have an account
  EOS
  def quizzes_update
    @group = Group.find(params[:id])
    authorize! :manage, @group
    @quizzes = params.require(:quizzes).map { |id| Quiz.find(id) }.uniq
    @group.update!(quizzes: @quizzes)
    head :ok
  end

  api :GET, '/groups/:id/students', "Returns the students from the group"
  param :id, :number, required: true, desc: "ID of group"
  error 404, "Couldn't find group"
  example <<-EOS
    [
      {
        "id": 1,
        "name": "John Smith",
        "email": "vlad@kcl.ac.uk"
      }
    ]
  EOS
  def students
    @group = Group.find(params[:id])
    authorize! :manage, @group
    render json: @group.students, each_serializer: UserGetSerializer
  end

  api :GET, '/groups/search', "Searches the groups"
  param :input, String, required: true, desc: "Search query"
  example <<-EOS
    {
      "best_match_name": [
        {
          "id": 1,
          "name": "input"
        }
      ],
      "alternative_match_name": [
        {
          "id": 2,
          "name": "something that contains input somewhere"
        }
      ]
    }
  EOS
  def search
    @best_match_name = Group.where(name: params.require(:input))

    @alternative_match_name = Group.where('name LIKE ?', "%#{params.require(:input)}%").all
      .reject{ |match| @best_match_name.include? match }
      .first(25)

    result = {
      best_match_name: ActiveModel::Serializer::CollectionSerializer.new(@best_match_name, serializer: GroupSearchSerializer),
      alternative_match_name: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_name, serializer: GroupSearchSerializer)
    }
    render json: result
  end
end
