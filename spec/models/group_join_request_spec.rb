require 'rails_helper'

RSpec.describe GroupJoinRequest, type: :model do
  describe "#send_email" do
    it "should send an email after create" do
      expect {
        create(:group_join_request)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
