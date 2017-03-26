require "rails_helper"

RSpec.describe GroupInviteMailer, type: :mailer do
  describe "notify" do
    let(:invite) { create(:group_invite) }
    let(:mail) { GroupInviteMailer.send_invite(invite) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have been invite to Interactive Language")
      expect(mail.to).to eq([invite.email])
      expect(mail.from).to eq(["hello@teamusr-frontend.herokuapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Please make an account at https://teamusr-frontend.herokuapp.com/")
    end
  end
end
