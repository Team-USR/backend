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
                left_choice: "left 1",
                right_choice: "right 1"
              },
              {
                left_choice: "left 2",
                right_choice: "right 2"
              }
            ]
          },
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
      request.env['CONTENT_TYPE'] = 'application/json'
      post :create, params: pa
      expect(assigns(:quiz)).to be_a(Quiz)
      expect(assigns(:quiz).title).to eq("My quiz")
      expect(assigns(:quiz).questions.size).to eq(3)
      expect(assigns(:quiz).questions.first.answers.size).to eq(2)
      expect(assigns(:quiz).questions.first.question).to eq("Question 1")
      expect(assigns(:quiz).questions.first.answers.first.answer).to eq("Answer 1")
      expect(assigns(:quiz).questions.second.pairs.first.left_choice).to eq("left 1")
      expect(assigns(:quiz).questions.second.pairs.last.left_choice).to eq("left 2")
      expect(assigns(:quiz).questions.last.question).to eq("Question 3")
      expect(assigns(:quiz).questions.last.answers.first.answer).to eq("Answer 1")
    end
  end
end
