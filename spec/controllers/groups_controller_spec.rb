require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:pa) do
    {
      name: "SEG Project Run",
      users_attributes: [
        {
          id: "1"
        },
        {
          id: "2"
        },
        {
          id: "3"
        }
      ]
    }
  end

  describe "POST #create" do
    it "assigns @group" do
      post :create, params: pa, as: :json
      expect(assigns(:group)).to be_a(Group)
      expect(assigns(:group).name).to eq("SEG Project Run")
      expect(assigns(:group).users.size).to eq(2)
      expect(assigns(:group).users.first.id).to eq(1)
      expect(assigns(:group).users.last.id).to eq(3)
    end
  end
end
