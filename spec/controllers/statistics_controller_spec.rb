require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  describe "GET #average_marks_groups" do
    let(:user) { create(:user) }
    let(:grp) { create(:group, admin: user) }
    let(:grp2) { create(:group, admin: user) }
    let(:g_u) { create(:groups_users, group: grp, user: user, role: "admin") }
    let(:g_u2) { create(:groups_users, group: grp2, user: user, role: "admin") }
    let(:quiz) { create(:quiz, user: user, attempts: 2) }
    let(:quiz2) { create(:quiz, user: user) }
    let(:session1) { create(:quiz_session, user: user, quiz: quiz, score: 5, state: "submitted") }
    let(:session2) { create(:quiz_session, user: user, quiz: quiz, score: 6, state: "submitted") }

    before do
      authenticate_user user
      grp.quizzes << quiz
      grp2.quizzes << quiz2
      quiz.quiz_sessions << session1
      quiz.quiz_sessions << session2
    end

    it "returns the right average" do
      get :average_marks_groups
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "group_id" => grp.id,
            "group_name" => grp.name,
            "average" => (session1.score + session2.score) / 2
          },
          {
            "group_id" => grp2.id,
            "group_name" => grp2.name,
            "average" => nil
          }
        ]
      )
    end
  end
end
