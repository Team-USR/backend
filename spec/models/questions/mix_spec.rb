require 'rails_helper'

RSpec.describe Questions::Mix, type: :model do
  subject { create(:mix_question, sentence_count: 6) }

  describe "factory" do
    context "with sentence_count = 4" do
      it "creates 4 sentences" do
        expect(create(:mix_question, sentence_count: 4).sentences.count)
          .to eq(4)
      end
    end

    context "with sentence_count = 0" do
      it "creates 0 sentences" do
        expect(create(:mix_question, sentence_count: 0).sentences.count)
          .to eq(0)
      end
    end
  end

  describe '#check' do
    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check({
        answer: ["RANDOM sentence"]
      }, true)).to eq({
        correct: false,
        points: -1,
        correct_sentences: subject.sentences.map(&:text)
      })
    end

    it 'returns true if the answer sent is the correct one' do
      expect(subject.check({
        answer: subject.sentences.first.text.split(" ")
      }, false)).to eq({
        correct: true,
        points: 1,
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
    subject { create(:mix_question, sentence_count: 0) }

    it "marks the question as invalid if there is no main question" do
      create(:sentence, text: "hello false", is_main: false, question: subject)
      create(:sentence, text: "hello false", is_main: false, question: subject)

      expect(subject.reload.valid?).to eq(false)
    end

    it "marks the question as invalid if there are many main sentences" do
      create(:sentence, text: "hello false", is_main: true, question: subject)
      create(:sentence, text: "hello false", is_main: true, question: subject)

      expect(subject.reload.valid?).to eq(false)
    end

    it "marks the question as invalid if there is no main sentences" do
      create(:sentence, text: "hello false", is_main: false, question: subject)
      create(:sentence, text: "hello false", is_main: false, question: subject)

      expect(subject.reload.valid?).to eq(false)
    end
  end

  describe "#save_format_correct?" do
    subject { create(:mix_question, sentence_count: 6) }

    it "returns true if the hash sent has correct key answer" do
      hash = {
        answer: [subject.words.first, subject.words.last]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "return false if the hash sent has words that do not belong to the sentence" do
      hash = {
        answer: [subject.words.first, subject.words.last, "ponta"]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the hash sent doesn't have key answer" do
      hash = {}
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the hash sent doesn't have key answer as an array" do
      hash = { answer: "hello" }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end
  end
end
