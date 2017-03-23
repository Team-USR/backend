require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
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
end
