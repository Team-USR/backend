require 'rails_helper'

RSpec.describe Questions::SingleChoice, type: :model do
  subject { create(:single_choice_question, answers_count: 4) }

  describe "factory" do
    context "with answers_count = 4" do
      it "creates 4 answers" do
        expect(create(:single_choice_question, answers_count: 4).answers.count)
          .to eq(4)
      end
    end

    context "with answers_count = 0" do
      it "creates 0 answers" do
        expect(create(:single_choice_question, answers_count: 0).answers.count)
          .to eq(0)
      end
    end
  end

  describe '#check' do
    let(:correct_answer) { subject.answers.find_by(is_correct: true) }
    let(:incorrect_answer) { subject.answers.find_by(is_correct: false) }

    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer_id: correct_answer.id
      }, true)).to eq({
        correct: true,
        points: 1,
        correct_answer: correct_answer.id
      })
    end

    it 'returns true if the id of the answer is the correct one' do
      expect(subject.check({
        answer_id: incorrect_answer.id
      }, true)).to eq({
        correct: false,
        points: -1,
        correct_answer: correct_answer.id
      })
    end
  end

  describe "#has_only_one_correct_answer" do
    subject { create(:single_choice_question) }
    it "marks the question as invalid if there's no correct answer" do
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      expect(subject.reload.valid?).to eq(false)
    end

    it "marks the question as invalid if there are multiple correct answer" do
      create(:answer, is_correct: true, question: subject)
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: true, question: subject)
      create(:answer, is_correct: false, question: subject)
      expect(subject.reload.valid?).to eq(false)
    end
  end

  describe "#save_format_correct?" do
    subject { create(:single_choice_question, answers_count: 4) }

    it "returns true if the hash sent has correct key answer_id" do
      expect(subject.save_format_correct?({ answer_id: subject.answers.first.id }))
        .to eq(true)
    end

    it "returns false if the hash sent has incorrect key answer_id" do
      expect(subject.save_format_correct?({ answer_id: -1 }))
        .to eq(false)
    end

    it "returns false if the hash sent doesn't have key answer_id" do
      expect(subject.save_format_correct?({}))
        .to eq(false)
    end
  end
end
