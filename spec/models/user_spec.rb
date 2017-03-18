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

  describe "#check_invites" do
    let(:email) { "test@gmail.com" }

    context "when there are invites pending before the create" do
      let!(:invite) { create(:group_invite, email: email) }

      it "adds the user to the group" do
        expect(create(:user, email: email).groups).to eq([invite.group])
      end

      it "destroys the invite after creating" do
        expect { create(:user, email: email).groups }
          .to change { GroupInvite.count }.by(-1)
      end
    end

    context "when there are not invites pending before the create" do
      it "adds the user to the group" do
        expect(create(:user, email: email).groups).to eq([])
      end
    end
  end
end
