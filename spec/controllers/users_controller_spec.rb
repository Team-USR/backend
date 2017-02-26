require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    it "create @user" do
      post :create, params: {
        user: {
          name: "Test",
          email: "test@test.com",
          password: "testing"
        }
      }
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user).name).to eq("Test")
      expect(assigns(:user).email).to eq("test@test.com")
    end

    it "creates a new user" do
      expect do
        post :create, params: {
                user: {
                name: "Test",
                email: "test@test.com",
                password: "testing"
              }
        }
      end.to change{ User.count }.from(0).to(1)
    end
  end

  describe "POST #update" do
    let(:user) { create(:user) }
    let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }
    let(:update_params) { { user: { email: "vlad@gm.c", name: "New Name" } } }
    let(:params) { update_params.merge(id: user_id) }

    before do
      request.headers["Authorization"] = "Bearer #{token}"
    end

    context "when trying to change current user" do
      let(:user_id) { user.id }

      it "sucesfully changes the user" do
        expect { patch :update, params: params }
          .to change { user.reload.email }.to("vlad@gm.c")
          .and change { user.name }.to("New Name")
      end
    end

    context "when trying to change another user" do
      let(:another_user) { create(:user) }
      let(:user_id) { another_user.id }

      it "sucesfully changes the user" do
        expect { patch :update, params: params }
          .to_not change { another_user }
      end

      it "returns an unauthorised error" do
        patch :update, params: params
        expect(response.status).to eq(401)
      end
    end
  end
end
