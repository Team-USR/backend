require 'rails_helper'

RSpec.describe QuizSerializer, type: :Serializer do
  context "with scope edit" do
    let!(:quiz) { create(:quiz) }
    let!(:single_choice_question) { create(:single_choice_question, quiz: quiz, answers_count: 2) }
    let!(:multiple_choice_question) { create(:multiple_choice_question, quiz: quiz, answers_count: 2) }
    let!(:mix_question) { create(:mix_question, quiz: quiz, sentence_count: 2) }
    let!(:match_default) { create(:match_default) }
    let!(:match_question) { create(:match_question, quiz: quiz, pairs_count: 2, match_default: match_default) }
    let!(:cloze_question) { create(:cloze_question, quiz: quiz, gap_count: 2) }
    let!(:cross_question) { create(:cross_question_with_data, quiz: quiz) }

    subject { QuizSerializer.new(quiz, scope: "edit") }

    it "contains the correct representation for single_choice" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: single_choice_question.question,
            id: single_choice_question.id,
            type: "single_choice",
            points: 1,
            answers: array_including(
              {
                id: single_choice_question.answers.first.id,
                answer: single_choice_question.answers.first.answer,
                is_correct: single_choice_question.answers.first.is_correct,
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for multiple_choice" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: multiple_choice_question.question,
            id: multiple_choice_question.id,
            type: "multiple_choice",
            points: 1,
            answers: array_including(
              {
                id: multiple_choice_question.answers.first.id,
                answer: multiple_choice_question.answers.first.answer,
                is_correct: multiple_choice_question.answers.first.is_correct,
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for mix" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: mix_question.question,
            id: mix_question.id,
            type: "mix",
            points: 1,
            sentences: array_including(
              {
                id: mix_question.sentences.first.id,
                text: mix_question.sentences.first.text,
                is_main: mix_question.sentences.first.is_main,
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for match" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: match_question.question,
            id: match_question.id,
            type: "match",
            points: 1,
            match_default: match_default.default_text,
            pairs: array_including(
              {
                id: match_question.pairs.first.id,
                left_choice: match_question.pairs.first.left_choice,
                right_choice: match_question.pairs.first.right_choice,
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for cloze" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: cloze_question.question,
            id: cloze_question.id,
            type: "cloze",
            points: 1,
            cloze_sentence: {
              text: cloze_question.cloze_sentence.text,
              id: cloze_question.cloze_sentence.id
            },
            gaps: array_including(
              {
                id: cloze_question.gaps.first.id,
                gap_text: cloze_question.gaps.first.gap_text,
                hint: {
                  id: cloze_question.gaps.first.hint.id,
                  hint_text: cloze_question.gaps.first.hint.hint_text,
                }
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for cross" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: cross_question.question,
            id: cross_question.id,
            type: "cross",
            points: 1,
            width: 3,
            height: 3,
            rows: [
              "ab*",
              "c*d",
              "e*f"
            ],
            hints: array_including(
              hash_including(
                across: true,
                row: 0,
                column: 0
              )
            )
          }
        )
      )
    end
  end

  context "with scope show" do
    let!(:quiz) { create(:quiz) }
    let!(:single_choice_question) { create(:single_choice_question, quiz: quiz, answers_count: 2) }
    let!(:multiple_choice_question) { create(:multiple_choice_question, quiz: quiz, answers_count: 2) }
    let!(:mix_question) { create(:mix_question, quiz: quiz, sentence_count: 2) }
    let!(:match_default) { create(:match_default) }
    let!(:match_question) { create(:match_question, quiz: quiz, pairs_count: 2, match_default: match_default) }
    let!(:cloze_question) { create(:cloze_question, quiz: quiz, gap_count: 2) }
    let!(:cross_question) { create(:cross_question_with_data, quiz: quiz) }

    subject { QuizSerializer.new(quiz, scope: "show") }

    it "contains the correct representation for single_choice" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: single_choice_question.question,
            id: single_choice_question.id,
            type: "single_choice",
            points: 1,
            answers: array_including(
              {
                id: single_choice_question.answers.first.id,
                answer: single_choice_question.answers.first.answer
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for multiple_choice" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: multiple_choice_question.question,
            id: multiple_choice_question.id,
            type: "multiple_choice",
            points: 1,
            answers: array_including(
              {
                id: multiple_choice_question.answers.first.id,
                answer: multiple_choice_question.answers.first.answer
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for mix" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: mix_question.question,
            id: mix_question.id,
            type: "mix",
            points: 1,
            words: array_including(
              mix_question.words.first
            )
          }
        )
      )
    end

    it "contains the correct representation for match" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: match_question.question,
            id: match_question.id,
            type: "match",
            points: 1,
            match_default: match_default.default_text,
            left: array_including(
              {
                answer: match_question.pairs.first.left_choice,
                id: match_question.pairs.first.left_choice_uuid
              }
            ),
            right: array_including(
              {
                answer: match_question.pairs.first.right_choice,
                id: match_question.pairs.first.right_choice_uuid
              }
            )
          }
        )
      )
    end

    it "contains the correct representation for cloze" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: cloze_question.question,
            id: cloze_question.id,
            type: "cloze",
            points: 1,
            sentence: cloze_question.cloze_sentence.text,
            hints: cloze_question.gaps.map { |gap| gap.hint.try(:hint_text) }
          }
        )
      )
    end

    it "contains the correct representation for cross" do
      expect(subject.as_json[:questions]).to match(
        array_including(
          {
            question: cross_question.question,
            id: cross_question.id,
            type: "cross",
            points: 1,
            width: 3,
            height: 3,
            rows: [
              "__*",
              "_*_",
              "_*_"
            ],
            hints: array_including(
              hash_including(
                across: true,
                row: 0,
                column: 0
              )
            )
          }
        )
      )
    end
  end
end
