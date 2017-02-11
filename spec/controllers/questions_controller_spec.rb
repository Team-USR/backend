require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:single_choice_question, :with_answers) }

  describe "GET #check_answer" do
    it "returns status false when the answer provided is false" do
      request.env['CONTENT_TYPE'] = 'application/json'
      get :check_answer, params: {
        id: question.id,
        answer_id: question.answers.last.id
      }
      parsed_json = JSON.parse(response.body)
      expect(parsed_json["status"]).to eq(false)
    end

    it "returns status true when the answer provided is true" do
      request.env['CONTENT_TYPE'] = 'application/json'
      get :check_answer, params: {
        id: question.id,
        answer_id: question.answers.first.id
      }
      parsed_json = JSON.parse(response.body)
      expect(parsed_json["status"]).to eq(true)
    end
  end
end
