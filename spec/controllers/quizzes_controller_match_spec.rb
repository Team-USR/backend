require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:pa) do
    {
      quiz: {
        title: "My quiz",
        questions_attributes: [
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
      expect(assigns(:quiz).questions.first.pairs.first.left_choice).to eq("left 1")
      expect(assigns(:quiz).questions.first.pairs.last.left_choice).to eq("left 2")
    end
  end
end
