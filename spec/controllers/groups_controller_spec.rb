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
      expect(assigns(:group).user).to eq(user)
    end
  end

  describe "POST #add" do
    let(:user) { create(:user) }
    let(:group) { create(:group, user: user) }

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
    let(:user) { create(:user) }
    let(:user) { create(:user) }
    let(:group) { create(:group, user: user) }

    before do
      authenticate_user user
      user.groups << group
    end

    it "assigns the user to the group" do
      expect do
        delete :delete, params: {
          id: group.id,
          user_id: user.id
        },
        as: :json
      end.to change { GroupsUser.count }.by(-1)
      expect(group.users.count).to eq(0)
      expect(user.groups.count).to eq(0)
    end
  end

  describe "QUIZZES #quizzes" do
    let(:user) { create(:user) }
    let(:group) { create(:group, user: user) }
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
    let(:group) { create(:group, user: user) }
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
    let(:group) { create(:group, user: user) }

    before do
      authenticate_user user
      group.users << create(:user)
      group.quizzes << create(:quiz)
    end

    it "destroys the quiz and all GroupUser" do
      expect { delete :destroy, params: { id: group.id } }
        .to change { Group.count }.by(-1)
        .and change { GroupsUser.count }.by(-1)
        .and change { GroupsQuiz.count }.by(-1)
        .and change { User.count }.by(0)
        .and change { Quiz.count }.by(0)
    end
  end
end
