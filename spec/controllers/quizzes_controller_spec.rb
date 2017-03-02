require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:user) }
    let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }

    let(:single_choice_params) do
      {
        question: "Single Choice Question",
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
    end

    let(:multiple_choice_params) do
      {
        question: "Multiple Choice Question",
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
          }
        ]
      }
    end

    let(:match_params) do
      {
        question: "Match Question",
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
    end

    let(:mix_params) do
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
      }
    end

    let(:cloze_params) do
      {
        question: "Question 5",
        type: "cloze",
        cloze_sentence_attributes: {
          "text": "test {1} before {2} after {3}"
        },
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
    end

    let(:questions_params) { [] }

    let(:params) do
      {
        quiz: {
          title: "My quiz",
          questions_attributes: questions_params
        }
      }
    end

    before do
      request.headers["Authorization"] = "Bearer #{token}"
    end

    it "creates a quiz with the correct title and user" do
      post :create, params: params, as: :json

      expect(assigns(:quiz)).to be_a(Quiz)
      expect(assigns(:quiz).title).to eq("My quiz")
      expect(assigns(:quiz).user).to eq(user)
    end

    context "when creating a single_choice question and a multiple_choice" do
      let(:questions_params) { [single_choice_params, multiple_choice_params] }

      it "creates the two questions" do
        post :create, params: params, as: :json

        expect(assigns(:quiz).questions.count).to eq(2)

        single_choice_question = assigns(:quiz).questions[0]
        expect(single_choice_question).to be_a(Questions::SingleChoice)
        expect(single_choice_question.question).to eq("Single Choice Question")
        expect(single_choice_question.answers.count).to eq(2)

        expect(single_choice_question.answers[0].is_correct).to eq(false)
        expect(single_choice_question.answers[1].is_correct).to eq(true)

        expect(single_choice_question.answers[0].answer).to eq("Answer 1")
        expect(single_choice_question.answers[1].answer).to eq("Answer 2")

        multiple_choice_question = assigns(:quiz).questions[1]
        expect(multiple_choice_question).to be_a(Questions::MultipleChoice)
        expect(multiple_choice_question.question).to eq("Multiple Choice Question")
        expect(multiple_choice_question.answers.count).to eq(4)

        expect(multiple_choice_question.answers[0].is_correct).to eq(false)
        expect(multiple_choice_question.answers[1].is_correct).to eq(true)
        expect(multiple_choice_question.answers[2].is_correct).to eq(true)
        expect(multiple_choice_question.answers[3].is_correct).to eq(false)

        expect(multiple_choice_question.answers[0].answer).to eq("Answer 1")
        expect(multiple_choice_question.answers[1].answer).to eq("Answer 2")
        expect(multiple_choice_question.answers[2].answer).to eq("Answer 3")
        expect(multiple_choice_question.answers[3].answer).to eq("Answer 4")
      end
    end

    context "when creating a match question" do
      let(:questions_params) { [match_params] }

      it "creates the question" do
        post :create, params: params, as: :json

        expect(assigns(:quiz).questions.count).to eq(1)

        match_question = assigns(:quiz).questions[0]
        expect(match_question).to be_a(Questions::Match)

        expect(match_question.pairs.sort[0].left_choice).to eq("left 1")
        expect(match_question.pairs.sort[1].left_choice).to eq("left 2")

        expect(match_question.pairs.sort[0].right_choice).to eq("right 1")
        expect(match_question.pairs.sort[1].right_choice).to eq("right 2")
      end
    end

    context "when creating a mix question" do
      let(:questions_params) { [mix_params] }

      it "creates the question" do
        post :create, params: params, as: :json

        expect(assigns(:quiz).questions.count).to eq(1)

        mix_question = assigns(:quiz).questions[0]
        expect(mix_question).to be_a(Questions::Mix)

        expect(mix_question.sentences.count).to eq(3)

        expect(mix_question.sentences[0].text).to eq("main sentence is here")
        expect(mix_question.sentences[1].text).to eq("sentence main here is")
        expect(mix_question.sentences[2].text).to eq("main sentence here is")

        expect(mix_question.sentences[0].is_main).to eq(true)
        expect(mix_question.sentences[1].is_main).to eq(false)
        expect(mix_question.sentences[2].is_main).to eq(false)
      end
    end

    context "when creating a cloze question" do
      let(:questions_params) { [cloze_params] }

      it "creates the question" do
        post :create, params: params, as: :json

        expect(assigns(:quiz).questions.count).to eq(1)

        cloze_question = assigns(:quiz).questions[0]
        expect(cloze_question).to be_a(Questions::Cloze)

        expect(cloze_question.cloze_sentence.text).to eq("test {1} before {2} after {3}")

        expect(cloze_question.gaps.count).to eq(3)

        expect(cloze_question.gaps.sort[0].gap_text).to eq("text 1")
        expect(cloze_question.gaps.sort[1].gap_text).to eq("text 2")
        expect(cloze_question.gaps.sort[2].gap_text).to eq("text 3")

        expect(cloze_question.gaps.sort[0].hint.hint_text).to eq("hint 1")
        expect(cloze_question.gaps.sort[1].hint).to be_nil
        expect(cloze_question.gaps.sort[2].hint).to be_nil
      end
    end
  end

  # We are not testing that #check works on the model as we have unit tests
  # for that. We are only testing if the correct response is outputted
  describe "GET #check" do
    let(:quiz) { create(:quiz) }
    let(:params) do
      {
        "id": quiz.id,
        "questions": questions_params
      }
    end

    context "checking a single question" do
      let(:single_choice_question) do
        create(:single_choice_question, answers_count: 4, quiz: quiz)
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

        it "returns the correct response" do
          post :check, params: params, as: :json

          expect(JSON.parse(response.body)).to eq(
            [
              {
                "id" => single_choice_question.id,
                "correct" => false,
                "correct_answer" => correct_answer.id
              }
            ]
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
        post :check, params: params, as: :json

        expect(JSON.parse(response.body)).to eq(
          [
            {
              "id" => -3,
              "status" => "Error; Question not found"
            }
          ]
        )
      end
    end
  end

  describe "POST #save" do
      let(:quiz) { create(:quiz) }
      let(:params) do
        {
          "id": quiz.id,
          "questions": questions_params
        }
      end

      context "saving a response with a single choice question" do
        let(:single_choice_question) do
          create(:single_choice_question, answers_count: 4, quiz: quiz)
        end
        let(:incorrect_answer) { single_choice_question.answers.find_by(is_correct: false) }
        let(:correct_answer) { single_choice_question.answers.find_by(is_correct: true) }
        context "with existing question id and good json format" do
          let(:questions_params) do
            [{
              id: single_choice_question.id,
              answer_id: answer_id
            }]
          end
          context "with good params" do
            let(:answer_id) { incorrect_answer.id }
            it "returns the correct response" do
              post :save, params: params, as: :json
              expect(JSON.parse(response.body)).to eq(
                [
                  {
                    "quiz_id" => quiz.id,
                    "user_id" => quiz.user_id,
                    "state" => "in_progress",
                    "metadata" =>
                      {
                      single_choice_question.id.to_s => {
                        "answer_id" => answer_id
                      }
                    }
                  }
                ]
              )
            end
          end
      end
      context "with non existing question id and good json format" do
        let(:questions_params) do
          [{
            id: 123456789,
            answer_id: answer_id
          }]
        end
        let(:answer_id) { incorrect_answer.id }
        it "returns an error" do
          post :save, params: params, as: :json
          expect(JSON.parse(response.body)).to eq(
            [
              {
                "id" => 123_456_789,
                "error" => "Error; Question not found"
              }
            ]
          )
        end
      end
      context "with existing question id and bad json format" do
        let(:questions_params) do
          [{
            id: single_choice_question.id,
            answr_id: answer_id
          }]
        end
        let(:answer_id) { incorrect_answer.id }
        it "returns an error" do
          post :save, params: params, as: :json
          expect(JSON.parse(response.body)).to eq(
            [
              {
                "error" => "Error; Wrong params format, check wiki"
              }
            ]
          )
        end
      end
      end
  end
end
