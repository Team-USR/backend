require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:pa) do
    {
      name: "SEG Project Run"
    }
  end

  describe "POST #create" do
    let(:user) { create(:user) }

    before do
      authenticate_user user
    end

    it "assigns @group" do
      post :create, params: pa, as: :json
      expect(assigns(:group)).to be_a(Group)
      expect(assigns(:group).name).to eq("SEG Project Run")
      expect(assigns(:group).admins).to eq([user])
    end
  end

  describe "POST #add" do
    let(:user) { create(:user) }
    let(:group) { create(:group, admin: user) }

    before do
      authenticate_user user
    end

    it "assigns the user to the group" do
      expect do
        post :add, params: {
          id: group.id,
          user_id: user.id
        },
        as: :json
      end.to change { GroupsUser.count }.by(1)
      expect(assigns(:group_user).user).to eq(user)
      expect(assigns(:group_user).group).to eq(group)
    end
  end

  describe "DELETE #delete" do
    let(:admin) { create(:user) }
    let(:user) { create(:user) }
    let(:group) { create(:group, admin: admin) }

    before do
      authenticate_user admin
      group.users << user
    end

    it "deletes the user from to the group" do
      expect do
        delete :delete, params: {
          id: group.id,
          user_id: user.id
        },
        as: :json
      end.to change { GroupsUser.count }.by(-1)
        .and change { group.users.count }.from(2).to(1)
        .and change { user.groups.count }.from(1).to(0)
    end
  end

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

  describe "#quizzes_update" do
    let(:user) { create(:user) }
    let(:group) { create(:group, admin: user) }
    let(:quiz1) { create(:quiz) }
    let(:quiz2) { create(:quiz) }
    let(:quiz3) { create(:quiz) }

    before do
      authenticate_user user
      group.quizzes << quiz3
    end

    it "overrides and updates the quizzes for the group" do
      post :quizzes_update, params: {
        id: group.id,
        quizzes: [quiz1.id, quiz2.id]
      }

      expect(group.reload.quizzes).to eq([quiz1, quiz2])
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }
    let(:group) { create(:group, admin: user) }

    before do
      authenticate_user user
      group.users << create(:user)
      group.quizzes << create(:quiz)
    end

    it "destroys the quiz and all GroupUser" do
      expect { delete :destroy, params: { id: group.id } }
        .to change { Group.count }.by(-1)
        .and change { GroupsUser.count }.by(-2)
        .and change { GroupsQuiz.count }.by(-1)
        .and change { User.count }.by(0)
        .and change { Quiz.count }.by(0)
    end
  end

  describe '#students' do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:user1) { create(:user) }

    before do
      authenticate_user user
      group.users << user1
    end

    it "shows the students in the group" do
      get :students, params: { id: group.id }
      expect(JSON.parse(response.body)).to eq(
        [
          {
              "id" => user1.id,
              "name" => user1.name,
              "email" => user1.email
          }
        ]
      )
    end
  end

  describe '#users_update' do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      authenticate_user user
      group.users << user1
    end

    it "updates the users and the admin is still included" do
      post :users_update, params:
        {
          id: group.id,
          users: [
            user2.email,
          ]
        }
      expect(group.reload.users.map(&:email).sort)
        .to eq([user, user2].map(&:email).sort)

      expect(JSON.parse(response.body)).to eq(
        [
          {
            "email" => user2.email,
            "status" => "added"
          }
        ]
      )
      expect(response.status).to eq(200)
    end

    it "schedules a job for each user  that doesn't have an email" do
      expect do
        post :users_update, params:
          {
            id: group.id,
            users: [
              "t@t.c",
              "c@c.c",
            ]
          }
      end.to enqueue_job(GroupInviteJob).twice

      expect(JSON.parse(response.body)).to match(
        [
          {
            "email" => "t@t.c",
            "status" => "invited_to_join"
          },
          {
            "email" => "c@c.c",
            "status" => "invited_to_join"
          }
        ]
      )
    end
  end

  describe "#edit" do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:user1) { create(:user) }

    before do
      authenticate_user user
      group.users << user1
      create(:group_invite, group: group, email: "test@gmail.com")
    end

    it "returns the expected format" do
      get :edit, params: { id: group.id }
      expect(JSON.parse(response.body)).to eq({
        "id" => group.id,
        "name" => group.name,
        "admins" => [user.email],
        "students" => [user1.email],
        "pending_invites" => ["test@gmail.com"]
      })
    end
  end

  describe "#search" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      authenticate_user user
    end
    it "returns the right best_match_name" do
      post :search, params: { input: group.name }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [
            {
              "id" => group.id,
              "name" => group.name
            }
          ],
          "alternative_match_name" => []
        }
      )
    end

    it "returns the right alternative_match_name" do
      post :search, params: { input: group.name.chop }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [],
          "alternative_match_name" => [
            {
              "id" => group.id,
              "name" => group.name
            }
          ]
        }
      )
    end
  end
end
