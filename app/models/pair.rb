class Pair < ApplicationRecord
  belongs_to :question, polymorphic: true
  before_create :create_unique_identifier

  validates_presence_of :left_choice, :right_choice

  def create_unique_identifier
    loop do
      self.left_choice_uuid = SecureRandom.urlsafe_base64(5)
      break unless self.class.exists?(left_choice_uuid: left_choice_uuid)
    end

    loop do
      self.right_choice_uuid = SecureRandom.urlsafe_base64(5)
      break unless self.class.exists?(right_choice_uuid: right_choice_uuid)
    end
  end
end
