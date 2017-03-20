class GroupInviteJob < ApplicationJob
  def perform(group, email)
    GroupInvite.create!(group: group, email: email)
  end
end
