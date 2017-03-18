class GroupInvite < ApplicationRecord
  belongs_to :group
  validates_presence_of :email

  after_create :send_email

  private

  def send_email
    GroupInviteMailer.send_invite(self).deliver_now
  end
end
