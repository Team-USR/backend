require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "QUIZZES #quizzes" do
    let(:user) { create(:user) }
    let(:group) { create(:group, admin: user) }
    let(:quiz) { create(:quiz) }

    before do
      authenticate_user user
      group.quizzes << quiz
    end

    let(:params) do
      {
        id: group.id
      }
    end

    it "shows the quizzes of the group" do
      get :quizzes, params: params, as: :json

      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => quiz.id,
            "title" => quiz.title,
            "published" => false
          }
        ]
      )
    end

    it "return an empty array if group has no quizzes" do
      group.quizzes.delete(group.quizzes.last)
      get :quizzes, params: params, as: :json

      expect(JSON.parse(response.body)).to eq([])
    end
  end
end
