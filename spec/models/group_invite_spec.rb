require 'rails_helper'

RSpec.describe GroupInvite, type: :model do
  subject { build(:group_invite) }

  it { should validate_presence_of(:email) }

  describe "#send_email" do
    it "should enqueue_job on mailer queue" do
      expect {
        create(:group_invite)
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end
