require 'rails_helper'

RSpec.describe PairChoice, type: :model do
  subject { create(:pair_choice) }
  it { should validate_presence_of(:title) }

  describe "#create_unique_identifier" do
    let(:pair_choices) { create_list(:pair_choice, 25) }

    it "creates 25 different uuid" do
      expect(pair_choices.map(&:uuid).uniq.size).to eq(25)
    end
  end
end
