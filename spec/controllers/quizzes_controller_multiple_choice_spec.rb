require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:pa) do
    {
      quiz: {
        title: "My quiz",
        questions_attributes: [
          {
            question: "Question 3",
            type: "multiple_choice",
            answers_attributes: [
              {
                answer: "Answer 1",
                is_correct: false
              },
              {
                answer: "Answer 2",
                is_correct: true
              },
              {
                answer: "Answer 3",
                is_correct: true
              },
              {
                answer: "Answer 4",
                is_correct: false
              },
              {
                answer: "Answer 5",
                is_correct: false
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
      expect(assigns(:quiz).title).to eq("My quiz")
      expect(assigns(:quiz).questions.size).to eq(1)
      expect(assigns(:quiz).questions.first.question).to eq("Question 3")
      expect(assigns(:quiz).questions.first.answers.first.answer).to eq("Answer 1")
    end
  end
end
