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
      end.to change{User.count}.from(0).to(1)
    end
  end
end
