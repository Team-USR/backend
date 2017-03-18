class GroupInviteMailer < ApplicationMailer
  def send_invite(group_invite)
    mail(
      to: group_invite.email,
      subject: "You have been invite to Interactive Language",
      body: "Please make an account at https://teamusr-frontend.herokuapp.com/"
    )
  end
end
