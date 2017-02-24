require 'rails_helper'

RSpec.describe Questions::Mix, type: :model do
  subject { FactoryGirl.create(:mix_question, sentence_count: 6) }

  describe '#check' do
    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer: "RANDOM sentence"
      })).to eq({
        correct: false,
        correct_sentences: subject.sentences.map(&:text)
      })
    end

    it 'returns true if the answer sent is the correct one' do
      expect(subject.check({
        answer: subject.sentences.first.text
      })).to eq({
        correct: true,
        correct_sentences: subject.sentences.map(&:text)
      })
    end
  end
  #
  # describe "#has_at_least_one_correct_answer" do
  #   subject { create(:multiple_choice_question) }
  #   it "marks the question as invalid if there's no correct answer" do
  #     create(:answer, is_correct: false, question: subject)
  #     create(:answer, is_correct: false, question: subject)
  #     create(:answer, is_correct: false, question: subject)
  #     create(:answer, is_correct: false, question: subject)
  #     expect(subject.reload.valid?).to eq(false)
  #   end
  # end
end
