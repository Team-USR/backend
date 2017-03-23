require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#for_groups" do
    let(:quiz) { create(:quiz) }
    let(:params) do
      {
      "id": quiz.id,
      "groups": groups_params
      }
    end
    context "assigning a quiz to two different groups" do
      let(:group_1) { create(:group) }
      let(:group_2) { create(:group) }

      let(:groups_params) do
        [
          group_1.id,
          group_2.id
        ]
      end
      it "returns the correct result" do
          expect do
            post :for_groups, params: params, as: :json
          end.to change { GroupsQuiz.count }.by(2)
          expect(group_1.quizzes.count).to eq(1)
          expect(group_2.quizzes.count).to eq(1)

          expect(response.status).to eq(201)
      end
    end

    context "assigns a quiz to the same group" do
      let(:group_1) { create(:group) }
      let(:groups_params) do
        [
          group_1.id,
          group_1.id
        ]
      end
      it "prints the correct error" do
        expect do
          post :for_groups, params: params, as: :json
        end.to change { GroupsQuiz.count }.by(1)
        expect(response.status).to eq(201)
      end
    end

    context "assigns a quiz to a non-existing group" do
      let(:groups_params) do
        [
          -1
        ]
      end
      it "prints the correct error" do
        post :for_groups, params: params, as: :json

        expect(response.status).to eq(404)
      end
    end
  end
end
