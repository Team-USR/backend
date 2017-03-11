class UsersController < ApplicationController
  def search
    @best_match_name = User.where(name: params[:input])
    @best_match_email = User.where(email: params[:input])

    @alternative_match_name = User.where('name LIKE ?', "%#{params[:input]}%").all
      .reject{ |match| @best_match_name.include? match}
      .first(25)
    @alternative_match_email = User.where('email LIKE ?', "%#{params[:input]}%").all
      .reject{ |match| @best_match_email.include? match}
      .reject{ |match| @alternative_match_name.include? match}
      .first(25)

    result = {
      best_match_name: ActiveModel::Serializer::CollectionSerializer.new(@best_match_name, serializer: UserGetSerializer),
      best_match_email: ActiveModel::Serializer::CollectionSerializer.new(@best_match_email, serializer: UserGetSerializer),
      alternative_match_name: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_name, serializer: UserGetSerializer),
      alternative_match_email: ActiveModel::Serializer::CollectionSerializer.new(@alternative_match_email, serializer: UserGetSerializer)
    }
    render json: result
  end
end
