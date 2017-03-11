require 'rails_helper'

RSpec.describe Users::MineController, type: :controller do
  describe "GET #groups" do
    let(:user) { create(:user) }
    let!(:group1) { create(:group, admin: user) }
    let!(:group2) do
      g = create(:group)
      g.users << user
      g
    end

    before do
      authenticate_user user
    end

    it "return the groups of the user" do
      get :groups
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => group1.id,
            "name" => group1.name,
            "admins" => [user.email]
          },
          {
            "id" => group2.id,
            "name" => group2.name,
            "admins" => []
          }
        ]
      )
    end
  end

  describe 'GET #quizzes' do
    let(:user) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:quiz) { create(:quiz, user: user) }

    before do
      authenticate_user user
    end

    it "returns the quizzes of the user" do
      get :quizzes
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => quiz.id,
            "title" => quiz.title,
            "status" => "not_started"
          }
        ]
      )
    end
  end
end
