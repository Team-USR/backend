class TestSecuredController < ApplicationController
  before_action :authenticate_user!

  def test
    render json: { data: "It worked" }
  end
end
