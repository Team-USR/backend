require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:pa) do
    {
      quiz: {
        title: "Single Choice Quiz",
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
                is_correct: true
              }
            ]
          }
        ]
      }
    }
  end

  describe "POST #create" do
    it "assigns @quiz" do
      post :create, params: pa, as: :json
      expect(assigns(:quiz)).to be_a(Quiz)
      expect(assigns(:quiz).title).to eq("Single Choice Quiz")
      expect(assigns(:quiz).questions.size).to eq(1)
      expect(assigns(:quiz).questions.first.answers.size).to eq(2)
      expect(assigns(:quiz).questions.first.question).to eq("Question 1")
      expect(assigns(:quiz).questions.first.answers.first.answer).to eq("Answer 1")
    end
  end
end
