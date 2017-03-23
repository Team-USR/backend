require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "#edit" do
    let!(:user) { create(:user) }
    let!(:group) { create(:group, admin: user) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      authenticate_user user
      group.users << user1
      create(:group_invite, group: group, email: "test@gmail.com")
      create(:group_join_request, group: group, user: user2)
    end

    it "returns the expected format" do
      get :edit, params: { id: group.id }
      expect(JSON.parse(response.body)).to eq({
        "id" => group.id,
        "name" => group.name,
        "admins" => [{
          "id" => user.id,
          "name" => user.name,
          "email" => user.email,
        }],
        "students" => [{
          "id" => user1.id,
          "name" => user1.name,
          "email" => user1.email,
        }],
        "pending_invite_users" => ["test@gmail.com"],
        "pending_requests_users" => [{
          "id" => user2.id,
          "name" => user2.name,
          "email" => user2.email,
        }],
      })
    end
  end
end
