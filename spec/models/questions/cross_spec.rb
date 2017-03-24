require 'rails_helper'

RSpec.describe Questions::Cross, type: :model do
  subject { create(:cross_question_with_data) }

  describe "#check" do
    it "returns false for a wrong list of rows" do
      expect(subject.check({
        rows: [
          "row",
          "row",
          "row"
        ]
      }, true)).to eq({
        correct: false,
        points: -1,
        correct_rows: subject.rows.map(&:row)
      })
    end

    it "returns true for a correct list of words" do
      expect(subject.check({
        rows: [
          "ab*",
          "c*d",
          "e*f"
        ]
      }, true)).to eq({
        correct: true,
        points: 1,
        correct_rows: subject.rows.map(&:row)
      })
    end
  end

  describe "#save_format_correct?" do
    subject { create(:cross_question_with_data) }

    it "returns true for a correct format" do
      hash = {
        rows: [
          "a",
          "b"
        ]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "returns false if the the rows is not an array" do
      hash = {
        rows: "a"
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the the rows attribute is not present" do
      hash = {}
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end
  end
end
