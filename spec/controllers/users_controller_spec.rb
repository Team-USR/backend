require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#search" do
    let(:user) { create(:user) }

    it "returns the right best_match_name" do
      post :search, params: { input: user.name }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [
            {
              "id" => user.id,
              "name" => user.name,
              "email" => user.email
            }
          ],
          "best_match_email" => [],
          "alternative_match_name" => [],
          "alternative_match_email" => []
        }
      )
    end

    it "returns the right best_match_email" do
      post :search, params: { input: user.email }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [],
          "best_match_email" => [
            {
              "id" => user.id,
              "name" => user.name,
              "email" => user.email
            }
          ],
          "alternative_match_name" => [],
          "alternative_match_email" => []
        }
      )
    end

    it "returns the right alternative_match_name" do
      post :search, params: { input: user.name.chop }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [],
          "best_match_email" => [],
          "alternative_match_name" => [
            {
              "id" => user.id,
              "name" => user.name,
              "email" => user.email
            }
          ],
          "alternative_match_email" => []
        }
      )
    end

    it "returns the right alternative_match_name" do
      post :search, params: { input: user.email.chop }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [],
          "best_match_email" => [],
          "alternative_match_name" => [],
          "alternative_match_email" => [
            {
              "id" => user.id,
              "name" => user.name,
              "email" => user.email
            }
          ]
        }
      )
    end
  end
end
