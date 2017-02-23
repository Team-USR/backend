require 'rails_helper'

RSpec.describe Questions::SingleChoice, type: :model do
  subject { create(:single_choice_question, answers_count: 4) }

  describe '#check' do
    let(:correct_answer) { subject.answers.find_by(is_correct: true) }
    let(:incorrect_answer) { subject.answers.find_by(is_correct: false) }

    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer_id: correct_answer.id
      })).to eq({
        correct: true,
        correct_answer: correct_answer.id
      })
    end

    it 'returns true if the id of the answer is the correct one' do
      expect(subject.check({
        answer_id: incorrect_answer.id
      })).to eq({
        correct: false,
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
end
