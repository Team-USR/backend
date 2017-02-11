require 'rails_helper'

RSpec.describe Pair, type: :model do
  subject { create(:pair) }

  describe "#factory" do
    it "creates the correct number of pairs" do
      create(:pair)
      expect(PairChoice.count).to eq(2)
      expect(Pair.count).to eq(1)
    end

    it "associates two different pair choices" do
      expect(subject.left_choice).to_not eq(subject.right_choice)
    end
  end
end
