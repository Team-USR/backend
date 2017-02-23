require 'rails_helper'

RSpec.describe Questions::Match, type: :model do
  subject { FactoryGirl.create(:match_question, pairs_count: 2) }

  describe "#check" do
    let(:pairs_param) do
      subject.pairs.map do |pair|
        {
          left_choice_id: pair.left_choice_uuid,
          right_choice_id: pair.right_choice_uuid
        }
      end
    end

    it "returns true for the correct combination of pairs" do
      expect(subject.check({
        pairs: pairs_param
      }).as_json).to eq(
        "correct" => true,
        "correct_pairs" => pairs_param
      )
    end

    it "returns false for the correct combination of pairs but with a missing pair" do
      expect(subject.check({
        pairs: pairs_param.drop(1)
      }).as_json).to eq(
        "correct" => false,
        "correct_pairs" => pairs_param
      )
    end

    it "returns false for a wrong combination of pair" do
      wrong_pairs = subject.pairs.map do |pair|
        {
          left_choice_id: pair.right_choice_uuid,
          right_choice_id: pair.left_choice_uuid
        }
      end

      expect(subject.check({
        pairs: wrong_pairs
      }).as_json).to eq(
        "correct" => false,
        "correct_pairs" => pairs_param
      )
    end
  end
end
