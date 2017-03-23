require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "#accept_join" do
    let!(:admin) { create(:user) }
    let!(:group) { create(:group, admin: admin) }
    let!(:user) { create(:user) }

    before do
      authenticate_user admin
    end

    context "when the request exists" do
      before do
        create(:group_join_request, group: group, user: user)
      end

      it "adds the user to the group and destroy the request" do
        expect { post :accept_join, params: { id: group.id, email: user.email } }
          .to change { GroupJoinRequest.count }.by(-1)
          .and change { group.reload.users.count }.by(1)

        expect(group.users).to include(user)
      end
    end

    context "when the doesn't exist" do
      it "doesn't add the user and it doesn't change join requests" do
        expect { post :accept_join, params: { id: group.id, email: user.email } }
          .to change { GroupJoinRequest.count }.by(0)
          .and change { group.reload.users.count }.by(0)

        expect(response.status).to eq(404)
        expect(response.body).to include("User didn't request join")
      end
    end
  end
end
