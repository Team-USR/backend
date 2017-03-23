require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "#save" do
    let!(:quiz) { create(:quiz) }
    let!(:single_choice_question) { create(:single_choice_question, quiz: quiz, answers_count: 3) }
    let(:user) { create(:user) }
    let!(:quiz_session) do
      create(:quiz_session, user: user, quiz: quiz, metadata: { "test": "a" })
    end

    before do
      authenticate_user user
    end

    context "with wrong quiz id" do
      it "returns 404 error" do
        post :save, params: { id: -1 }
        expect(response.status).to eq(404)
      end
    end

    describe "creating_sessions" do
      context "when no session exists" do
        let!(:quiz_session) { nil }

        it "creates a new session" do
          expect { post :save, params: { id: quiz.id } }
            .to change { QuizSession.count }.by(1)
        end
      end

      context "when session exists" do
        it "doesn't create a new session" do
          expect { post :save, params: { id: quiz.id } }
            .to change { QuizSession.count }.by(0)
        end
      end
    end

    describe "checking if params are correct" do
      let(:question_id) { single_choice_question.id }
      let(:params) do
        {
          id: quiz.id,
          questions: [
            id: question_id
          ]
        }
      end

      context "with wrong question_id" do
        let(:question_id) { -1 }

        it "returns 404 error" do
          post :save, params: params
          expect(response.status).to eq(404)
        end

        it "doesn't change the session" do
          expect { post :save, params: params }
            .to_not change { quiz_session }
        end
      end

      context "with wrong format" do
        it "returns 400 error" do
          post :save, params: params
          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)).to eq(
            "errors" => [
              {
                "code" => "invalid_parameter",
                "detail" => "Wrong parameters sent for question with id #{single_choice_question.id}"
              }
            ]
          )
        end

        it "doesn't change the session" do
          expect { post :save, params: params }
            .to_not change { quiz_session }
        end
      end

      context "with correct format but with answer that doesn't exist" do
        let(:params) do
          {
            id: quiz.id,
            questions: [
              id: question_id,
              answer_id: -1
            ]
          }
        end

        it "returns 400 error" do
          post :save, params: params
          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)).to eq(
            "errors" => [
              {
                "code" => "invalid_parameter",
                "detail" => "Wrong parameters sent for question with id #{single_choice_question.id}"
              }
            ]
          )
        end

        it "doesn't change the session" do
          expect { post :save, params: params }
            .to_not change { quiz_session }
        end
      end

      context "with correct format" do
        let(:params) do
          {
            id: quiz.id,
            questions: [
              id: question_id,
              answer_id: single_choice_question.answers.first.id
            ]
          }
        end
        it "returns 200 status" do
          post :save, params: params
          expect(response.status).to eq(200)
        end

        it "updates the session" do
          expect { post :save, params: params }
            .to change { quiz_session.reload.metadata }
            .from({ "test" => "a" })
            .to({
              single_choice_question.id.to_s => {
                "answer_id" => single_choice_question.answers.first.id.to_s
              }
            })
        end
      end
    end
  end
end
