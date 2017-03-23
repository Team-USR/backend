require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
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
end
