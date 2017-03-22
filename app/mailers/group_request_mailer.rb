class GroupRequestMailer < ApplicationMailer
  def send_invite(group_request)
    group_request.group.admins.each do |email|
      mail(
        to: email,
        subject: "#{group_request.user.name} requested to join #{group_request.group.name}",
        body: "Please accept this at https://teamusr-frontend.herokuapp.com/"
      )
    end
  end
end
