class GroupInviteJob < ApplicationJob
  def perform(invite)
    GroupInvite.create!(group: invite.group, email: invite.email)
  end
end
