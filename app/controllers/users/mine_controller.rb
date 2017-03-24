class Users::MineController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    formats ['json']
    error 401, "Need to be logged in"
  end

  api :GET, '/users/mine/groups', "Returns user's groups"
  example <<-EOS
    [
      {
        "id": 1,
        "name": "Group use2",
        "creator": "mihnea@gmail.com",
        "role": "admin"
      },
      {
        "id": 2,
        "name": "Group us2",
        "creator": "mihnea@gmail.com",
        "role": "student"
      }
    ]
  EOS
  def groups
    render json: current_user.groups_users
  end

  api :GET, '/users/mine/quizzes', "Returns user's all quizzes from all groups"
  example <<-EOS
    [
      {
        "id": 3,
        "title": "My quiz",
        "status": "not_started"
      }
    ]
  EOS
  def quizzes
    render json: current_user.groups
    .reject{ |group_admined_by| group_admined_by.admins.include? current_user }
    .flat_map(&:quizzes)
    .reject{ |quiz| quiz.published == false }
    .reject{ |quiz| quiz.release_date.present? && quiz.release_date > Date.today }, each_serializer: MyQuizzesSerializer
  end

  api :GET, '/users/mine/requests', "Returns the list of requests to join groups made by the user"
  example <<-EOS
    [
      {
        "requested_at": "Requested on 03/23/2017 at 01:01PM",
        "group": {
          "id": 44,
          "name": "group6"
        }
      }
    ]
  EOS
  def requests
    render json: current_user.group_join_requests
  end

  api :GET, '/users/mine/submitted', "Returns the list of submitted quizzes by the user"
  example <<-EOS
    [
      {
        "state": "submitted",
        "last_updated": "Last updated on 03/23/2017 at 01:01PM",
        "metadata":
          {
            "test": "a"
          },
        "quiz_title": "My quiz",
        "score": 10
        }
      ]
  EOS
  def submitted
    sessions = QuizSession.where(user: current_user, state: "submitted")
    render json: sessions
  end
end
