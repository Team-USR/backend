require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#publish" do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz, user: user) }

    before do
      authenticate_user user
    end

    it "publishes the quiz" do
      expect { post :publish, params: { id: quiz.id } }
        .to change { quiz.reload.published }.to(true)

      expect(response.status).to eq(200)
    end
  end
end
