require 'rails_helper'
require_relative './quizzes_params'

RSpec.describe QuizzesController, type: :controller do
  include_context :quizzes_params

  describe "#update" do
    let(:user) { create(:user) }

    let(:quiz) { create(:quiz, title: "123", user: user) }

    before do
      quiz.questions << create(:single_choice_question, answers_count: 4)
      quiz.questions << create(:single_choice_question, answers_count: 1)
      quiz.questions << create(:multiple_choice_question, answers_count: 5)
      quiz.questions << create(:mix_question, quiz: quiz)
      authenticate_user user
    end

    context "with invalid quiz params" do
      it "returns status 400" do
        post :update, params: {
          id: quiz.id, quiz: { title: nil }
        }, as: :json
        expect(response.status).to eq(422)
      end

      it "returns an appropiate error message" do
        post :update, params: {
          id: quiz.id, quiz: { title: nil }
        }, as: :json
        expect(JSON.parse(response.body)).to match(
          "errors" => array_including(
            {
              "code" => "validation_error",
              "detail" => "Title can't be blank"
            }
          )
        )
      end
    end

    context "quiz not published yet" do
      it "updates the quiz" do
        params = {
          id: quiz.id,
          quiz: {
            title: "231",
            questions_attributes: [
              single_choice_params,
              match_params
            ]
          }
        }

        expect { patch :update, params: params, as: :json }
          .to change { quiz.reload.title }.from("123").to("231")
          .and change { quiz.questions.count }.from(4).to(2)
          .and change { Questions::Match.count }.by(1)
          .and change { Questions::SingleChoice.count }.by(-1)
          .and change { Questions::MultipleChoice.count }.from(1).to(0)
          .and change { Answer.count }.by(- 5 - 4 - 1 + 2)
          .and change { Questions::Mix.count }.by(-1)
      end
    end

    context "quiz published" do
      let(:quiz1) { create(:quiz, title: "123", user: user, published: true) }
      it "return 405" do
        params = {
          id: quiz1.id,
          quiz: {
            title: "231",
            questions_attributes: [
            ]
          }
        }

        patch :update, params: params, as: :json
        expect(response.status).to eq(405)
      end
    end
  end
end
