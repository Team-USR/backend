require 'rails_helper'
require_relative './quizzes_params'

RSpec.describe QuizzesController, type: :controller do
  include_context :quizzes_params

  describe "POST #create" do
    let(:user) { create(:user) }

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
      authenticate_user user
    end

    context "with wrong type param" do
      let(:questions_params) do
        [
          {
            type: "random"
          }
        ]
      end

      it "returns status 400" do
        post :create, params: params, as: :json
        expect(response.status).to eq(400)
      end

      it "return an error that describes the error" do
        post :create, params: params, as: :json
        expect(JSON.parse(response.body)).to eq({
          "errors" => [{
            "code" => "invalid_parameter",
            "detail" => "random is not a valid question type"
          }]
        })
      end
    end

    context "with invalid quiz params" do
      it "returns status 400" do
        post :create, params: { quiz: { title: nil } }, as: :json
        expect(response.status).to eq(422)
      end

      it "returns an appropiate error message" do
        post :create, params: { quiz: { title: nil } }, as: :json
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

    context "when creating a cloze question" do
      let(:questions_params) { [cross_params] }

      it "creates the question" do
        post :create, params: params, as: :json

        expect(assigns(:quiz).questions.count).to eq(1)

        cross_question = assigns(:quiz).questions[0]
        expect(cross_question).to be_a(Questions::Cross)

        expect(cross_question.metadata.width).to eq(4)
        expect(cross_question.metadata.height).to eq(4)

        expect(cross_question.rows.count).to eq(4)

        expect(cross_question.rows[0].row).to eq("*abc")
        expect(cross_question.rows[1].row).to eq("*h*d")
        expect(cross_question.rows[2].row).to eq("*e*f")
        expect(cross_question.rows[3].row).to eq("***g")

        expect(cross_question.hints.count).to eq(4)

        expect(cross_question.hints.sort[0].hint).to eq("abc")
        expect(cross_question.hints.sort[0].row).to eq(0)
        expect(cross_question.hints.sort[0].column).to eq(1)
        expect(cross_question.hints.sort[0].across).to eq(true)

        expect(cross_question.hints.sort.last.across).to eq(false)
      end
    end
  end
end
