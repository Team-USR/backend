require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:pa) do
    {
      quiz: {
        title: "My quiz",
        questions_attributes: [
          {
            question: "Question 1",
            type: "single_choice",
            answers_attributes: [
              {
                answer: "Answer 1",
                is_correct: false
              },
              {
                answer: "Answer 2",
                is_correct: false
              }
            ]
          },
          {
            question: "Question 2",
            type: "match",
            pairs_attributes: [
              {
                "left_choice_attributes": { "title": "left 1" },
                "right_choice_attributes": { "title": "right 1" }
              },
              {
                "left_choice_attributes": { "title": "left 2" },
                "right_choice_attributes": { "title": "right 2" }
              }
            ]
          }
        ]
      }
    }
  end
  describe "POST #create" do
    it "assigns @quiz" do
      request.env['CONTENT_TYPE'] = 'application/json'
      post :create, params: pa
      expect(assigns(:quiz)).to be_a(Quiz)
      expect(assigns(:quiz).title).to eq("My quiz")
      expect(assigns(:quiz).questions.size).to eq(2)
      expect(assigns(:quiz).questions.first.answers.size).to eq(2)
      expect(assigns(:quiz).questions.first.question).to eq("Question 1")
      expect(assigns(:quiz).questions.first.answers.first.answer).to eq("Answer 1")
      expect(assigns(:quiz).questions.last.pairs.first.left_choice.title).to eq("left 1")
    end
  end
end
