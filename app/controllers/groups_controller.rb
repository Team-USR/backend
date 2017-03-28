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
  example <<-EOS
  {
    "id": 1,
    "name": "Group Name",
    "admins": [
      {
        "id": 1,
        "name": "Admin 1",
        "email": "admin@example.com"
      },
    ],
    "students": [
      {
        "id": 2,
        "name": "Student 1",
        "email": "student@example.com"
      },
    ],
    "pending_invite_users": [
      "email1@gmail.com"
    ],
    "pending_requests_users": [
      {
        "id": 2,
        "name": "Student 1",
        "email": "student@example.com"
      },
    ]
  }
  EOS
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
    @group_invites = []

    @users_status = params.require(:users).map do |user_email|
      if user = User.find_by_email(user_email)
        @users << user
        {
          email: user_email,
          status: "added"
        }
      else
        @group_invites << { email: user_email, group: @group }
        {
          email: user_email,
          status: "invited_to_join"
        }
      end
    end

    GroupInvite.create!(@group_invites)
    @group.update!(users: (@users + @group.admins))

    render json: @users_status, status: :ok
  end

  api :POST, '/groups/:id/add_users', "Updates (overrides) the users of the group"
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
    Adds a list of users to the group. If some user in the list doesn't have an account, an email
    will be sent to his email address to invite him to the group.
  EOS
  def add_users
    @group = Group.find(params[:id])
    authorize! :manage, @group

    @users = []
    @group_invites = []
    @new_users = []

    @users_status = params.require(:users).map do |user_email|
      if user = User.find_by_email(user_email)
        if !@group.users.include? user
          @new_users << user
        end
        {
          email: user_email,
          status: "added"
        }
      else
        # GroupInviteJob.perform_later(@group, user_email)
        @group_invites << { email: user_email, group: @group }
        {
          email: user_email,
          status: "invited_to_join"
        }
      end
    end

    @group.users << @new_users
    GroupInvite.create!(@group_invites)
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
    if params.key?(:quizzes) && (!params[:quizzes].empty? || !params[:quizzes].nil?)
      @quizzes = params.require(:quizzes).map { |id| Quiz.find(id) }.uniq
      @group.update!(quizzes: @quizzes)
    else
      @group.quizzes.destroy_all
    end
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
    render json: @group.students, each_serializer: UserSerializer
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
    @best_match_name = Group.where("lower(name) = ? ", params.require(:input).downcase)

    @alternative_match_name = Group.where('name ILIKE ?', "%#{params.require(:input)}%").all
      .reject{ |match| @best_match_name.include? match }
      .first(25)

    result = {
      best_match_name: ActiveModel::Serializer::CollectionSerializer.new(@best_match_name, serializer: GroupSerializer),
      alternative_match_name: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_name, serializer: GroupSerializer)
    }
    render json: result
  end

  api :POST, '/groups/:id/request_join', "Create a request to join the a group"
  param :id, :number, required: true, desc: "ID of group"
  error 404, "Couldn't find group"
  def request_join
    @group = Group.find(params[:id])
    GroupJoinRequest.find_or_create_by!(group: @group, user: current_user)
    head :ok
  end

  api :POST, '/groups/:id/accept_join', "Accept a request"
  param :id, :number, required: true, desc: "ID of group"
  param :email, String, required: true, desc: "Email of user accepted"
  error 404, "Request not found"
  error 404, "Couldn't find group"
  def accept_join
    @group = Group.find(params[:id])
    @user = User.find_by!(email: params.require(:email))
    authorize! :manage, @group
    group_join_request = GroupJoinRequest.find_by(group: @group, user: @user)
    if group_join_request.present?
      @group.users << group_join_request.user
      group_join_request.destroy!
    else
      render_error(status: :not_found, code: "request_not_present", detail: "User didn't request join")
    end
  end

  api :POST, '/groups/:id/decline_join', "Declines a request"
  param :id, :number, required: true, desc: "ID of group"
  param :email, String, required: true, desc: "Email of user who requested access"
  error 404, "Request not found"
  error 404, "Couldn't find group"
  def decline_join
    @group = Group.find(params[:id])
    @user = User.find_by!(email: params.require(:email))
    group_join_request = GroupJoinRequest.find_by(group: @group, user: @user)
    if group_join_request.present?
      group_join_request.destroy!
      head :ok
    else
    render_error(status: :not_found, code: "request_not_present", detail: "User didn't request join")
    end
  end
end
