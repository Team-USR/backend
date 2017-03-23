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
            "admins" => group2.admins.map(&:email),
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
    let!(:quiz) { create(:quiz, user: user, attempts: 1, published: true) }
    let!(:quiz1) { create(:quiz, user: user, attempts: 1, published: false) }
    let!(:g_u) { create(:groups_user, group: group, user: user2) }
    let!(:g_q) { create(:groups_quiz, group: group, quiz: quiz) }
    let!(:g_q1) { create(:groups_quiz, group: group, quiz: quiz1) }

    before do
      authenticate_user user2
    end

    it "returns the published quizzes with an empty session" do
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

    it "doesn't return the quizzes in the group for a group admin" do
      authenticate_user user
      get :quizzes
      expect(JSON.parse(response.body)).to eq([])
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

  describe "#requests" do
    let!(:user) { create(:user) }
    let!(:group) { create(:group) }
    let!(:request) { create(:group_join_request, user: user, group: group) }
    let!(:another_request) { create(:group_join_request, group: group) }

    before do
      authenticate_user user
    end

    it "returns the correct requests" do
      get :requests
      expect(JSON.parse(response.body)).to eq([{
        "requested_at" => request.created_at.strftime("Requested on %m/%d/%Y at %I:%M%p"),
        "group" => {
          "id" => group.id,
          "name" => group.name
        }
      }])
    end
  end
end
