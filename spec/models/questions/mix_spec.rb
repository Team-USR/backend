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

  describe "#sentences_have_same_words" do
    subject { create(:mix_question) }
    it "marks the question as invalid if the sentences don't have the same words" do
      create(:sentence, text: "hello false", is_main: true, question: subject)
      create(:sentence, text: "hello true", question: subject)

      expect(subject.reload.valid?).to eq(false)
    end
  end

  describe "#has_one_main_sentence" do
    it "marks the question as invalid if there is no main question" do
      create(:sentence, text: "hello false", is_main: false, question: subject)
      create(:sentence, text: "hello false", is_main: false, question: subject)

      expect(subject.reload.valid?).to eq(false)
    end

    it "marks the question as invalid if there are multiple question" do
      create(:sentence, text: "hello false", is_main: true, question: subject)
      create(:sentence, text: "hello false", is_main: true, question: subject)

      expect(subject.reload.valid?).to eq(false)
    end
  end
end
