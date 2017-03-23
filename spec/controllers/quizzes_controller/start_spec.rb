require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#start" do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:quiz) { create(:quiz, user: user, attempts: 2) }
    let(:params) { { id: quiz.id } }
    let!(:session) { create(:quiz_session, quiz: quiz, user: user1, state: "submitted", score: 0) }
    let!(:session1) { create(:quiz_session, quiz: quiz, user: user1, state: "in_progress") }

    before do
      authenticate_user user
      authenticate_user user1
    end

    it "returns the right json" do
      get :start, params: params
      session_created_at = session.created_at.strftime("Created on %m/%d/%Y at %I:%M%p")
      session_updated_at = session.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p")
      session1_created_at = session1.created_at.strftime("Created on %m/%d/%Y at %I:%M%p")
      session1_updated_at = session1.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p")
      expect(JSON.parse(response.body)).to eq(
        "quiz" => {
          "id" => quiz.id,
          "title" => quiz.title,
          "attempts" => quiz.attempts,
          "creator" => quiz.user.email,
          "creator_name" => quiz.user.name
        },
        "sessions" => [
          {
            "state" => session.state,
            "created_at" => session_created_at,
            "last_updated" => session_updated_at,
            "score" => session.score
          },
          {
            "state" => session1.state,
            "created_at" => session1_created_at,
            "last_updated" => session1_updated_at,
          }
        ]
      )
    end
  end
end
