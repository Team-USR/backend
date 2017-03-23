require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:pa) { { name: "SEG Project Run" } }

  describe "POST #create" do
    let(:user) { create(:user) }

    before do
      authenticate_user user
    end

    it "assigns @group" do
      post :create, params: pa, as: :json
      expect(assigns(:group)).to be_a(Group)
      expect(assigns(:group).name).to eq("SEG Project Run")
      expect(assigns(:group).admins).to eq([user])
    end

    context "with invalid group params" do
      it "returns status 400" do
        post :create, params: { group: { name: nil } }, as: :json
        expect(response.status).to eq(422)
      end

      it "returns an appropiate error message" do
        post :create, params: { group: { name: nil } }, as: :json
        expect(JSON.parse(response.body)).to match(
          "errors" => array_including(
            {
              "code" => "validation_error",
              "detail" => "Name can't be blank"
            }
          )
        )
      end
    end
  end
end
