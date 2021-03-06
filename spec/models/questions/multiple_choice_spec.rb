require 'rails_helper'

RSpec.describe Questions::MultipleChoice, type: :model do
  subject { FactoryGirl.create(:multiple_choice_question, answers_count: 5) }

  describe "factory" do
    context "with answers_count = 4" do
      it "creates 4 answers" do
        expect(create(:multiple_choice_question, answers_count: 4).answers.count)
          .to eq(4)
      end
    end

    context "with answers_count = 0" do
      it "returns an error" do
        expect { create(:multiple_choice_question, answers_count: 0) }
          .to raise_error
      end
    end
  end

  describe '#check' do
    let(:correct_answers) { subject.answers.where(is_correct: true).map(&:id).sort }

    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer_ids: correct_answers
      }, true)).to eq({
        correct: true,
        points: 1,
        correct_answers: correct_answers
      })
    end

    it 'returns true if the id of the answer is the correct one' do
      expect(subject.check({
        answer_ids: [subject.answers.find_by(is_correct: false)]
      }, true)).to eq({
        correct: false,
        points: -1,
        correct_answers: correct_answers
      })
    end
  end

  describe "#has_at_least_one_correct_answer" do
    subject { build(:multiple_choice_question, answers_count: 0) }
    it "marks the question as invalid if there's no correct answer" do
      subject.answers << build(:answer, is_correct: false)
      subject.answers << build(:answer, is_correct: false)
      subject.answers << build(:answer, is_correct: false)
      subject.answers << build(:answer, is_correct: false)

      expect(subject.valid?).to eq(false)
      expect(subject.errors.full_messages).to eq([
        "Answers doesn't have any correct answers"
      ])
    end
  end

  describe "#save_format_correct?" do
    subject { create(:multiple_choice_question, answers_count: 4) }

    it "returns true if the hash sent has correct key answer_ids" do
      hash = {
        answer_ids: [subject.answers.first.id, subject.answers.last.id]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "returns false if the hash sent has incorrect key answer_id" do
      hash = {
        answer_ids: [subject.answers.first.id, subject.answers.last.id, -1]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "returns false if the hash sent doesn't have key answer_ids" do
      expect(subject.save_format_correct?({}))
        .to eq(false)
    end

    it "returns false if the hash sent doesn't have key answer_ids as an array" do
      expect(subject.save_format_correct?({ answer_ids: "test" }))
        .to eq(false)
    end
  end
end
