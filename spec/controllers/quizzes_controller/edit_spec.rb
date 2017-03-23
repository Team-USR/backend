require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#edit" do
    let(:user) { create(:user) }

    before do
      authenticate_user user
    end

    let(:quiz) { create(:quiz, user: user) }
    let!(:question) { create(:single_choice_question, quiz: quiz, answers_count: 4) }

    it "returns status 200" do
      get :edit, params: { id: quiz.id }
      expect(response.status).to eq(200)
    end

    it "returns the correct response format using quiz serializer" do
      get :edit, params: { id: quiz.id }
      expect(response.body).to include("is_correct")
    end
  end
end
