class GroupJoinRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user
  validates_presence_of :group, :user

  after_create :send_email

  private

  def send_email
    GroupRequestMailer.send_invite(self).deliver_now
  end
end
