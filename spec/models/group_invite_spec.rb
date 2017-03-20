require 'rails_helper'

RSpec.describe GroupInvite, type: :model do
  subject { build(:group_invite) }

  it { should validate_presence_of(:email) }

  describe "#send_email" do
    it "should send an email after create" do
      expect {
        create(:group_invite)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
