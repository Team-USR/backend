require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe "#search" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      authenticate_user user
    end

    it "returns the right best_match_name" do
      post :search, params: { input: group.name }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [
            {
              "id" => group.id,
              "name" => group.name
            }
          ],
          "alternative_match_name" => []
        }
      )
    end

    it "returns the right best_match_name even if different case" do
      post :search, params: { input: group.name.upcase }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [
            {
              "id" => group.id,
              "name" => group.name
            }
          ],
          "alternative_match_name" => []
        }
      )
    end

    it "returns the right alternative_match_name" do
      post :search, params: { input: group.name.chop }, as: :json
      expect(JSON.parse(response.body)).to eq(
        {
          "best_match_name" => [],
          "alternative_match_name" => [
            {
              "id" => group.id,
              "name" => group.name
            }
          ]
        }
      )
    end
  end
end
