require 'rails_helper'

RSpec.describe Questions::Match, type: :model do
  subject { create(:cloze_question, gap_count: 4) }

  describe "factory" do
    context "with gap_count = 4" do
      it "creates 4 gaps" do
        expect(create(:cloze_question, gap_count: 4).gaps.count)
          .to eq(4)
      end
    end
  end

  describe "require cloze_sentence" do
    it "is invalid without a cloze_sentence" do
      q = Questions::Cloze.new(
        question: "1",
        quiz: create(:quiz)
      )
      expect(q.valid?).to eq(false)
      expect(q.errors.full_messages).to eq([
        "Cloze sentence must exist"
      ])
    end
  end

  describe "#check" do
    it "returns false for a wrong list of words" do
      expect(subject.check({
        answer_gaps: [
          "random",
          "words"
        ]
      }, true)).to eq({
        correct: false,
        points: -1,
        correct_gaps: subject.gap_order.split(",")
      })
    end

    it "returns true for a correct list of words" do
      expect(subject.check({
        answer_gaps: subject.gap_order.split(",")
      }, true)).to eq({
        correct: true,
        points: 1,
        correct_gaps: subject.gap_order.split(",")
      })
    end
  end

  describe "#save_format_correct?" do
    subject { create(:cloze_question, gap_count: 4) }

    it "returns true for a correct format" do
      hash = {
        answer_gaps: [
          subject.gaps[0].gap_text,
          subject.gaps[1].gap_text
        ]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "return false if the the answer_gaps attribute is not an array" do
      hash = {
        answer_gaps: "voiculescu"
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the the answer_gaps attribute is not present" do
      hash = {}
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the the answer_gaps elements are not strings" do
      hash = {
        answer_gaps: [{ "hello": 1 }]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end
  end
end
