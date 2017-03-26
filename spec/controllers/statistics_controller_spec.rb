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
            "average" => ((session1.score + session2.score) / 2).to_s
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

  describe "GET #average_marks_groups" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:grp) { create(:group, admin: user) }
    let(:grp2) { create(:group, admin: user) }
    let(:g_u) { create(:groups_users, group: grp, user: user, role: "admin") }
    let(:g_u2) { create(:groups_users, group: grp, user: user2, role: "student") }
    let(:g_u3) { create(:groups_users, group: grp2, user: user, role: "admin") }
    let(:g_u4) { create(:groups_users, group: grp2, user: user2, role: "student") }
    let(:quiz) { create(:quiz, user: user, attempts: 2) }
    let(:quiz2) { create(:quiz, user: user) }
    let(:session1) { create(:quiz_session, user: user2, quiz: quiz, score: 5, state: "submitted") }
    let(:session2) { create(:quiz_session, user: user2, quiz: quiz, score: 6, state: "submitted") }

    before do
      authenticate_user user2
      grp.users << user2
      grp2.users << user2
      grp.quizzes << quiz
      grp2.quizzes << quiz
      quiz.quiz_sessions << session1
      quiz.quiz_sessions << session2
    end

    let(:params) { { id: grp2.id } }

    it "returns the right average" do
      get :marks_groups_quizzes, params: params, as: :json
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "group_id" => grp2.id,
            "group_name" => grp2.name,
            "marks" =>
            {
              "quiz_name" => quiz.title,
              "score" => 6.0
            }
          }
        ]
      )
    end
  end
end
