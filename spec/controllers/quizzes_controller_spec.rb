require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
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

  describe "#mine" do
    let!(:user1) { create(:user) }
    let!(:quiz1) { create(:quiz, user: user1) }
    let!(:quiz2) { create(:quiz, user: user1) }
    let!(:user2) { create(:user) }
    let!(:quiz3) { create(:quiz, user: user2) }

    context "authenticated as user 1" do
      before do
        authenticate_user user1
      end

      it "returns the correct quizzes" do
        get :mine
        expect(JSON.parse(response.body).map { |quiz| quiz["id"] }.sort).to eq([quiz1.id, quiz2.id].sort)
      end
    end

    context "authenticated as user 2" do
      before do
        authenticate_user user2
      end

      it "returns the correct quizzes" do
        get :mine
        expect(JSON.parse(response.body).map { |quiz| quiz["id"] }.sort).to eq([quiz3.id])
      end
    end
  end

  describe "#update" do
    let(:user) { create(:user) }

    let(:quiz) { create(:quiz, title: "123", user: user) }

    before do
      quiz.questions << create(:single_choice_question, answers_count: 4)
      quiz.questions << create(:single_choice_question, answers_count: 0)
      quiz.questions << create(:multiple_choice_question, answers_count: 5)
      quiz.questions << create(:mix_question, quiz: quiz)
      authenticate_user user
    end

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

      expect { post :update, params: params, as: :json }
        .to change { quiz.reload.title }.from("123").to("231")
        .and change { quiz.questions.count }.from(4).to(2)
        .and change { Questions::Match.count }.by(1)
        .and change { Questions::SingleChoice.count }.by(-1)
        .and change { Questions::MultipleChoice.count }.from(1).to(0)
        .and change { Answer.count }.by(- 5 - 4 + 2)
        .and change { Questions::Mix.count }.by(-1)
    end
  end

  describe "#for_groups" do
    let(:quiz) { create(:quiz) }
    let(:params) do
      {
      "id": quiz.id,
      "groups": groups_params
      }
    end
    context "assigning a quiz to two different groups" do
      let(:group_1) { create(:group) }
      let(:group_2) { create(:group) }

      let(:groups_params) do
        [
          group_1.id,
          group_2.id
        ]
      end
      it "returns the correct result" do
          expect do
            post :for_groups, params: params, as: :json
          end.to change { GroupsQuiz.count }.by(2)
          expect(group_1.quizzes.count).to eq(1)
          expect(group_2.quizzes.count).to eq(1)

          expect(response.status).to eq(201)
      end
    end

    context "assigns a quiz to the same group" do
      let(:group_1) { create(:group) }
      let(:groups_params) do
        [
          group_1.id,
          group_1.id
        ]
      end
      it "prints the correct error" do
        expect do
          post :for_groups, params: params, as: :json
        end.to change { GroupsQuiz.count }.by(1)
        expect(response.status).to eq(201)
      end
    end

    context "assigns a quiz to a non-existing group" do
      let(:groups_params) do
        [
          -1
        ]
      end
      it "prints the correct error" do
        post :for_groups, params: params, as: :json

        expect(response.status).to eq(404)
      end
    end
  end
end
