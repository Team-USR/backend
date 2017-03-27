class UsersController < ApplicationController
  api :GET, '/groups/search', "Searches the users"
  param :input, String, required: true, desc: "Search query"
  example <<-EOS
    {
      "best_match_name": [
        {
          "id": 1,
          "name": "input"
        }
      ],
      "best_match_email": [
        {
          "id": 2,
          "name": "exactlyinput@gmail.com"
        }
      ],
      "alternative_match_name": [
        {
          "id": 3,
          "name": "John input a"
        }
      ],
      "alternative_match_name": [
        {
          "id": 3,
          "name": "inputbb@gmail.com"
        }
      ]
    }
  EOS
  def search
    @best_match_name = User.where("lower(name) = ? ", params.require(:input).downcase)
    @best_match_email = User.where("lower(email) = ? ", params.require(:input).downcase)

    @alternative_match_name = User.where('name LIKE ?', "%#{params[:input]}%").all
      .reject{ |match| @best_match_name.include? match }
      .first(25)
    @alternative_match_email = User.where('email LIKE ?', "%#{params[:input]}%").all
      .reject{ |match| @best_match_email.include? match }
      .reject{ |match| @alternative_match_name.include? match }
      .first(25)

    result = {
      best_match_name: ActiveModel::Serializer::CollectionSerializer.new(@best_match_name, serializer: UserSerializer),
      best_match_email: ActiveModel::Serializer::CollectionSerializer.new(@best_match_email, serializer: UserSerializer),
      alternative_match_name: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_name, serializer: UserSerializer),
      alternative_match_email: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_email, serializer: UserSerializer)
    }
    render json: result
  end
end
