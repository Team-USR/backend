require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }

  describe "#student?" do
    context "with a simple user" do
      it "returns false" do
        expect(subject.student?).to eq(false)
      end
    end

    context "with a student user" do
      subject { create(:user, :student) }

      it "returns true" do
        expect(subject.student?).to eq(true)
      end
    end
  end
end
