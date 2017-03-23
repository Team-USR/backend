require 'rails_helper'

RSpec.describe Questions::Match, type: :model do
  subject { create(:match_question, pairs_count: 2) }

  describe "factory" do
    context "with pairs_count = 4" do
      it "creates 4 pairs" do
        expect(create(:match_question, pairs_count: 4).pairs.count)
          .to eq(4)
      end
    end

    context "with pairs_count = 0" do
      it "creates 0 pairs" do
        expect(create(:match_question, pairs_count: 0).pairs.count)
          .to eq(0)
      end
    end
  end

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
        "points" => 1,
        "correct_pairs" => pairs_param
      )
    end

    it "returns false for the correct combination of pairs but with a missing pair" do
      expect(subject.check({
        pairs: pairs_param.drop(1)
      }).as_json).to eq(
        "correct" => false,
        "points" => 0.5,
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
        "points" => -1,
        "correct_pairs" => pairs_param
      )
    end
  end

  describe "#save_format_correct?" do
    subject { create(:match_question, pairs_count: 2) }

    it "returns true for a correct format" do
      hash = {
        pairs: [
          {
            left_choice_id: subject.pairs.first.left_choice_uuid,
            right_choice_id: subject.pairs.first.right_choice_uuid,
          }
        ]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "returns true if the the pairs array has a pair that doesn't exist" do
      hash = {
        pairs: [
          {
            left_choice_id: subject.pairs.first.left_choice_uuid,
            right_choice_id: subject.pairs.first.right_choice_uuid,
          },
          {
            left_choice_id: -1,
            right_choice_id: -2
          }
        ]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(true)
    end

    it "return false if the the pairs attribute is not an array" do
      hash = {
        pairs: "test"
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "return false if the the pairs attribute is not present" do
      hash = {}
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end

    it "returns false if the pairs attribute is not correct" do
      hash = {
        pairs: [
          {
            a: 1
          }
        ]
      }
      expect(subject.save_format_correct?(hash))
        .to eq(false)
    end
  end
end
