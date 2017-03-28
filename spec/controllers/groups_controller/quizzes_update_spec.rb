require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
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

    it "deletes quizzes when array is empty" do
      post :quizzes_update, params: {
        id: group.id,
        quizzes: []
      }

      expect(group.reload.quizzes).to be_empty
    end

    it "deletes quizzes when array is not present" do
      post :quizzes_update, params: {
        id: group.id
      }

      expect(group.reload.quizzes).to be_empty
    end
  end
end
