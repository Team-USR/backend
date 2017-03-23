require 'rails_helper'

# We are not testing that #submit works on the model as we have unit tests
# for that. We are only testing if the correct response is outputted
RSpec.describe QuizzesController, type: :controller do
  describe "POST #submit" do
    let(:user) { create(:user) }
    let!(:session) { create(:quiz_session, quiz: quiz, user: user) }

    before do
      authenticate_user user
    end
    let(:quiz) { create(:quiz, attempts: 1) }
    let(:params) do
      {
        "id": quiz.id,
        "questions": questions_params
      }
    end

    context "checking a quiz with no attempts left" do
      let(:quiz2) { create(:quiz, attempts: 0) }
      let(:questions_params) do
        []
      end
      let(:params2) do
        {
          "id": quiz2.id,
          "questions": questions_params
        }
      end

      it "should return no attempts left" do
        post :submit, params: params2, as: :json
        expect(JSON.parse(response.body)).to eq(
          {
            "errors" =>
            [
              {
                "code" => "not_found",
                "detail" => "Couldn't find QuizSession"
                }
                ]
              }
        )
      end
    end

    context "checking a single question" do
      let(:single_choice_question) do
        create(:single_choice_question, answers_count: 4, quiz: quiz, points: 1)
      end

      let(:incorrect_answer) { single_choice_question.answers.find_by(is_correct: false) }
      let(:correct_answer) { single_choice_question.answers.find_by(is_correct: true) }

      let(:questions_params) do
        [{
          id: single_choice_question.id,
          answer_id: answer_id
        }]
      end

      context "with a wrong answer id" do
        let(:answer_id) { incorrect_answer.id }

        it "updates the quiz session state" do
          expect { post :submit, params: params, as: :json }
            .to change { session.reload.state }.to("submitted")
        end

        it "updates the quiz session metadata" do
          post :submit, params: params, as: :json
          expect(session.reload.metadata).to eq([{
            "id" => single_choice_question.id,
            "answer_id" => answer_id
          }])
        end

        it "returns the correct response" do
          post :submit, params: params, as: :json

          expect(JSON.parse(response.body)).to eq(
            {
              "points" => -1.0,
              "feedback" => [
                {
                  "id" => single_choice_question.id,
                  "points" => -1.0,
                  "correct" => false,
                  "correct_answer" => correct_answer.id
                }
              ]
            }
          )
        end
      end

      context "with a correct answer_id" do
        let(:answer_id) { correct_answer.id }

        it "returns the correct response" do
          post :submit, params: params, as: :json

          expect(JSON.parse(response.body)).to eq(
            {
              "points" => 1,
              "feedback" => [
                {
                  "id" => single_choice_question.id,
                  "points" => 1,
                  "correct" => true,
                  "correct_answer" => correct_answer.id
                }
              ]
            }
          )
        end
      end
    end

    context "with a question id that doesn't exist" do
      let(:questions_params) do
        [{
          id: -3,
          answer_id: -2
        }]
      end

      it "returns the correct response" do
        post :submit, params: params, as: :json

        expect(JSON.parse(response.body)).to eq(
          {
            "points" => 0.0,
            "feedback" => [
              {
                "id" => -3,
                "status" => "Error; Question not found"
              }
            ]
          }
        )
      end
    end
  end
end
