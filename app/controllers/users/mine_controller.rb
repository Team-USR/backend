class Users::MineController < ApplicationController
  before_action :authenticate_user!

  resource_description do
    formats ['json']
    error 401, "Need to be logged in"
  end

  def groups
    render json: current_user.groups_users
  end

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

  def submitted
    sessions = QuizSession.where(user: current_user, state: "submitted")
    render json: sessions
  end
end
