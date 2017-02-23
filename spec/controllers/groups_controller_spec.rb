require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:pa) do
    {
      name: "SEG Project Run"
    }
  end

  describe "POST #create" do
    it "assigns @group" do
      post :create, params: pa, as: :json
      expect(assigns(:group)).to be_a(Group)
      expect(assigns(:group).name).to eq("SEG Project Run")
    end
  end

  describe "POST #add" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

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
    let(:group) { create(:group) }

    before do
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
end
