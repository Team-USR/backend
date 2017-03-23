require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
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
end
