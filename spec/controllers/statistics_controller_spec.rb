require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  describe "GET #average_marks_groups" do
    let(:user) { create(:user) }
    let(:grp) { create(:group, admin: user) }
    let(:g_u) { create(:groups_users, group: grp, user: user, role: "admin") }
    let(:quiz) { create(:quiz, user: user, attempts: 2) }
    let(:session1) { create(:quiz_session, user: user, quiz: quiz, score: 5, state: "submitted") }
    let(:session2) { create(:quiz_session, user: user, quiz: quiz, score: 6, state: "submitted") }

    before do
      authenticate_user user
      grp.quizzes << quiz
      quiz.quiz_sessions << session1
      quiz.quiz_sessions << session2
    end

    it "returns the right average" do
      get :average_marks_groups
      expect(JSON.parse(response.body)).to eq(
        {
          "points" => [
            5.5
          ]
        }
      )
    end
  end
end
