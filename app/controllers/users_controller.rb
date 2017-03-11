class UsersController < ApplicationController
  def search
    @best_match_name = User.where(name: params[:input])
    @best_match_email = User.where(email: params[:input])

    @alternative_match_name = User.where('name LIKE ?', "%#{params[:input]}%").all.reject{ |match| @best_match_name.include? match}
    @alternative_match_email = User.where('email LIKE ?', "%#{params[:input]}%").all.reject{ |match| @best_match_email.include? match}

    result = {
      best_match_name: @best_match_name,
      best_match_email: @best_match_email,
      alternative_match_name: @alternative_match_name,
      alternative_match_email: @alternative_match_email
    }
    render json: result
  end
end
