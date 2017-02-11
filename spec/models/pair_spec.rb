require 'rails_helper'

RSpec.describe Pair, type: :model do
  subject { create(:pair) }
  it { should validate_presence_of(:left_choice) }
  it { should validate_presence_of(:right_choice) }

  describe "#create_unique_identifier" do
    let(:pair_choices) { create_list(:pair, 25) }

    it "creates 50 different uuid" do
      uuid = pair_choices.map(&:left_choice_uuid) + pair_choices.map(&:right_choice_uuid)
      expect(uuid.size).to eq(50)
    end
  end
end
