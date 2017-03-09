require 'rails_helper'

RSpec.describe Users::MineController, type: :controller do
  describe "#groups" do
    let(:user) { create(:user) }
    let!(:group1) { create(:group, user: user) }
    let!(:group2) { create(:group, user: user) }

    before do
      authenticate_user user
    end

    it "return the groups of the user" do
      get :groups
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => group1.id,
            "name" => group1.name,
            "creator" => user.email
          },
          {
            "id" => group2.id,
            "name" => group2.name,
            "creator" => user.email
          }
        ]
      )
    end
  end
end
