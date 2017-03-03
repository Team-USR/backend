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
      it "creates 0 answers" do
        expect(create(:multiple_choice_question, answers_count: 0).answers.count)
          .to eq(0)
      end
    end
  end

  describe '#check' do
    let(:correct_answers) { subject.answers.where(is_correct: true).map(&:id).sort }

    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer_ids: correct_answers
      })).to eq({
        correct: true,
        correct_answers: correct_answers
      })
    end

    it 'returns true if the id of the answer is the correct one' do
      expect(subject.check({
        answer_ids: [subject.answers.find_by(is_correct: false)]
      })).to eq({
        correct: false,
        correct_answers: correct_answers
      })
    end
  end

  describe "#has_at_least_one_correct_answer" do
    subject { create(:multiple_choice_question) }
    it "marks the question as invalid if there's no correct answer" do
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      create(:answer, is_correct: false, question: subject)
      expect(subject.reload.valid?).to eq(false)
    end
  end
end
