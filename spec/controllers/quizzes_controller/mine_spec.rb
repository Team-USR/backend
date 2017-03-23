require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#mine" do
    let!(:user1) { create(:user) }
    let!(:quiz1) { create(:quiz, user: user1) }
    let!(:quiz2) { create(:quiz, user: user1) }
    let!(:user2) { create(:user) }
    let!(:quiz3) { create(:quiz, user: user2) }

    context "authenticated as user 1" do
      before do
        authenticate_user user1
      end

      it "returns the correct quizzes" do
        get :mine
        expect(JSON.parse(response.body).map { |quiz| quiz["id"] }.sort).to eq([quiz1.id, quiz2.id].sort)
      end
    end

    context "authenticated as user 2" do
      before do
        authenticate_user user2
      end

      it "returns the correct quizzes" do
        get :mine
        expect(JSON.parse(response.body).map { |quiz| quiz["id"] }.sort).to eq([quiz3.id])
      end
    end
  end
end
