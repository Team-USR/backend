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

    it "return the groups of the user where the user was created and where the user was added" do
      get :groups
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => group1.id,
            "name" => group1.name,
            "admins" => [user.email],
            "role" => "admin"
          },
          {
            "id" => group2.id,
            "name" => group2.name,
            "admins" => [],
            "role" => "student"
          }
        ]
      )
    end
  end

  describe 'GET #quizzes' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:quiz) { create(:quiz, user: user) }
    let!(:g_u) { create(:groups_user, group: group, user: user2) }
    let!(:g_q) { create(:groups_quiz, group: group, quiz: quiz) }

    before do
      authenticate_user user2
    end

    it "returns the quizzes with an empty session" do
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

    it "returns the quizzes with a non empty session" do
      session = QuizSession.create!(quiz: quiz, user: user2, metadata: { "hello": "test" } )
      get :quizzes
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => quiz.id,
            "title" => quiz.title,
            "status" => session.state
          }
        ]
      )
    end
  end
end
