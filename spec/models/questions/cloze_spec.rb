require 'rails_helper'

RSpec.describe Questions::Match, type: :model do
  subject { FactoryGirl.create(:cloze_question, gap_count: 4) }

  describe "#check" do
    it "returns false for a wrong list of words" do
      expect(subject.check({
        answer_gaps: [
          "random",
          "words"
        ]
      })).to eq({
        correct: false,
        correct_gaps: subject.gap_order.split(",")
      })
    end

    it "returns true for a correct list of words" do
      expect(subject.check({
        answer_gaps: subject.gap_order.split(",")
      })).to eq({
        correct: true,
        correct_gaps: subject.gap_order.split(",")
      })
    end
  end
end
