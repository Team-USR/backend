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
                is_correct: true
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
          },
          {
            question: "Question 4",
            type: "mix",
            sentences_attributes: [
              {
                "text": "main sentence is here",
                "is_main": true
              },
              {
                "text": "sentence main here is",
                "is_main": false
              },
              {
                "text": "main sentence here is",
                "is_main": false
              }
            ]
          },
          {
            question: "Question 5",
            type: "cloze",
            gaps_attributes: [
              {
                "gap_text": "text 1",
                hint_attributes:
                  {
                    "hint_text": "hint 1"
                  }
              },
              {
                "gap_text": "text 2"
              },
              {
                "gap_text": "text 3"
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
      expect(assigns(:quiz).questions.size).to eq(5)
      expect(assigns(:quiz).questions.first.answers.size).to eq(2)
      expect(assigns(:quiz).questions.first.question).to eq("Question 1")
      expect(assigns(:quiz).questions.first.answers.first.answer).to eq("Answer 1")
      expect(assigns(:quiz).questions.second.pairs.first.left_choice).to eq("left 1")
      expect(assigns(:quiz).questions.second.pairs.last.left_choice).to eq("left 2")
      expect(assigns(:quiz).questions[2].question).to eq("Question 3")
      expect(assigns(:quiz).questions[2].answers.first.answer).to eq("Answer 1")
    end
  end

  describe "GET #check" do
    let(:quiz) do
      pa[:quiz][:questions_attributes].try(:each) do |question_params|
        question_params[:type] = Question.type_from_api(question_params[:type])
      end

      Quiz.create(pa[:quiz])
    end

    let(:check_params) do
      {
        "id": quiz.id,
        "questions": [
          {
            "id": quiz.questions[0].id,
            "answer_id": quiz.questions[0].answers.last.id
          },
          {
            "id": quiz.questions[1].id,
            "pairs": [
              {
                "left_choice_id": quiz.questions[1].pairs.first.left_choice_uuid,
                "right_choice_id": quiz.questions[1].pairs.first.right_choice_uuid,
              },
              {
                "left_choice_id": quiz.questions[1].pairs.last.left_choice_uuid,
                "right_choice_id": quiz.questions[1].pairs.last.right_choice_uuid,
              }
            ]
          },
          {
            "id": quiz.questions[2].id,
            "answer_ids": [-1, -2]
          },
          {
            "id": -3
          },
          {
            "id": quiz.questions[3].id,
            "answer": "main sentence is here"
          },
          {
            "id": quiz.questions[4].id,
            "answer": "text 1,text 2,text 3"
          }
        ]
      }
    end

    it "returns the correct array" do
      post :check, params: check_params, as: :json
      expect(JSON.parse(response.body)).to eq(
        [
          {
            "id" => quiz.questions[0].id,
            "correct" => true,
            "correct_answer" => quiz.questions[0].answers.last.id
          },
          {
            "id" => quiz.questions[1].id,
            "correct" => true,
            "correct_pairs" => [
              {
                "left_choice_id" => quiz.questions[1].pairs.first.left_choice_uuid,
                "right_choice_id" => quiz.questions[1].pairs.first.right_choice_uuid,
              },
              {
                "left_choice_id" => quiz.questions[1].pairs.last.left_choice_uuid,
                "right_choice_id" => quiz.questions[1].pairs.last.right_choice_uuid,
              }
            ]
          },
          {
            "id" => quiz.questions[2].id,
            "correct" => false,
            "correct_answers" => quiz.questions[2].answers.where(is_correct: true).map(&:id)
          },
          {
            "id" => -3,
            "status" => "Error; Question not found"
          },
          {
            "id" => quiz.questions[3].id,
            "correct" => true,
            "correct_sentences" => [
              "main sentence is here",
              "sentence main here is",
              "main sentence here is"
            ]
          },
          {
            "id" => quiz.questions[4].id,
            "correct" => true,
            "correct_gaps" => [
              "text 1",
              "text 2",
              "text 3"
            ]
          }
        ]
      )
    end
  end
end
