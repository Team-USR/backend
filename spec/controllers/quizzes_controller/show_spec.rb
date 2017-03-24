require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "GET #show" do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz, user: user, attempts: 2) }
    let(:params) { { id: quiz.id } }

    before do
      authenticate_user user
    end

    context "with a quiz with a release date later than today" do
      let(:quiz_with_release_date) { create(:quiz, user: user, release_date: Date.tomorrow) }
      let(:params_release_date) { { id: quiz_with_release_date.id } }
      it "should return an error" do
        get :show, params: params_release_date, as: :json
        expect(JSON.parse(response.body)).to eq(
          {
            "errors" => [
              {
                "code" => "quiz_not_released_yet",
                "detail" => nil
              }
            ]
          }
        )
      end
    end

    context "without an existing session" do
      it "creates a new session" do
        expect { get :show, params: params, as: :json }
          .to change { QuizSession.count }.by(1)
      end

      it "returns an empty session" do
        get :show, params: params, as: :json
        expect(JSON.parse(response.body)["quiz_session"]).to eq(
          {
            "state" => "in_progress",
            "last_updated" => quiz.quiz_sessions.first.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p"),
            "metadata" => nil,
            "quiz_title" => quiz.title
          }
        )
      end
    end

    context "with an existing session" do
      let!(:session) { create(:quiz_session, quiz: quiz, user: user, metadata: { "id": 1, "answer_id": 1 }) }

      it "doesn't create a session" do
        expect { get :show, params: params, as: :json }
          .to change { QuizSession.count }.by(0)
      end

      it "returns the session" do
        get :show, params: params, as: :json
        expect(JSON.parse(response.body)["quiz_session"]["metadata"]).to eq(
          {
            "id" => 1,
            "answer_id" => 1
          }
        )
      end
    end

    context "with an existing session submitted" do
      let!(:session) do
        create(
          :quiz_session,
          quiz: quiz,
          user: user,
          metadata: { "id": 1, "answer_id": 1 },
          state: "submitted"
        )
      end
      it "creates a new session" do
        expect { get :show, params: params, as: :json }
          .to change { QuizSession.count }.by(1)
      end

      it "returns an empty session" do
        get :show, params: params, as: :json
        expect(JSON.parse(response.body)["quiz_session"]).to eq(
          {
            "state" => "in_progress",
            "last_updated" => quiz.quiz_sessions.first.updated_at.strftime("Last updated on %m/%d/%Y at %I:%M%p"),
            "metadata" => nil,
            "quiz_title" => quiz.title
          }
        )
      end

      context "with limit reached" do
        let(:quiz) { create(:quiz, user: user, attempts: 1) }

        it "throws a 421 error" do
          get :show, params: params, as: :json
          expect(response.status).to eq(405)
        end

        it "return an error message that says there are no more attempts left" do
          get :show, params: params, as: :json
          expect(JSON.parse(response.body)).to eq({
            "errors" => [{
              "code" => "no_attempts_left",
              "detail" => "You have used all your attempts!"
            }]
          })
        end
      end
    end

    describe "serialized data" do
      let(:user) { create(:user) }
      let(:quiz) do
        quiz = create(:quiz, user: user, attempts: 1)
        quiz.questions << create(:single_choice_question, answers_count: 4)
        quiz
      end
      let(:params) { { id: quiz.id } }

      before do
        authenticate_user user
      end

      it "doesn't return sensitive data" do
        get :show, params: params, as: :json
        expect(response.body).to_not include("is_correct")
        expect(response.body).to include("answer")
      end
    end
  end
end
