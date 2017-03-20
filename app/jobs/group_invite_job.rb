class GroupInviteJob < ApplicationJob
  def perform(group, email)
    GroupInvite.create!(group_id: group.id, email: email)
  end
end
