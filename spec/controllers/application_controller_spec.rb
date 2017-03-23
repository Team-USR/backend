require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#rescue_from_param_missing" do
    controller do
      def index
        params.require(:a)
      end
    end

    it "returns status 400" do
      get :index
      expect(response.status).to eq(400)
    end

    it "returns a message saying that a param is missing" do
      get :index
      expect(JSON.parse(response.body)).to eq({
        "errors" => [{
          "code" => "param_missing",
          "detail" => "param is missing or the value is empty: a"
        }]
      })
    end
  end

  describe "#rescue_from_param_missing" do
    controller do
      def index
        raise ApplicationController::InvalidParameter.new("Param is badly formatted")
      end
    end

    it "returns status 400" do
      get :index
      expect(response.status).to eq(400)
    end

    it "returns a message saying that a param is badly formatted" do
      get :index
      expect(JSON.parse(response.body)).to eq({
        "errors" => [{
          "code" => "invalid_parameter",
          "detail" => "Param is badly formatted"
        }]
      })
    end
  end

  describe "#rescue_from_unauthorised_cancan_access" do
    controller do
      def index;
        authorize! :manage, FactoryGirl.create(:group)
      end
    end

    before do
      authenticate_user create(:user)
    end

    it "returns status 401" do
      get :index
      expect(response.status).to eq(401)
    end

    it "returns a message saying that a param is badly formatted" do
      get :index
      expect(JSON.parse(response.body)).to eq({
        "errors" => [{
          "code" => "access_denied",
          "detail" => "You are not authorized to access this page."
        }]
      })
    end
  end

  describe "#rescue_from_record_not_found" do
    controller do
      def index
        Quiz.find(-1)
      end
    end

    it "returns status 404" do
      get :index
      expect(response.status).to eq(404)
    end

    it "returns a message saying that a param is badly formatted" do
      get :index
      expect(JSON.parse(response.body)).to eq({
        "errors" => [{
          "code" => "not_found",
          "detail" => "Couldn't find Quiz with 'id'=-1"
        }]
      })
    end
  end

  describe "#configure_permitted_parameters" do
    controller do
      def devise_controller?
        true
      end

      def resource_name
        "sign_up"
      end

      def index
        # return 200 if param was added
        if devise_parameter_sanitizer.instance_values['permitted'][:sign_up].include?(:name)
          head :ok
        else
          head :bad_request
        end
      end
    end

    it "adds the permitted field to devise" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
