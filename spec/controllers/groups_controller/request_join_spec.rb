require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "#request_join" do
    let!(:user) { create(:user) }
    let!(:group) { create(:group) }

    before do
      authenticate_user user
    end

    it "creates a join request" do
      expect { post :request_join, params: { id: group.id } }
        .to change { GroupJoinRequest.count }.by(1)

      expect(GroupJoinRequest.last.group).to eq(group)
      expect(GroupJoinRequest.last.user).to eq(user)
    end
  end
end
