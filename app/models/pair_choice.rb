class PairChoice < ApplicationRecord
  before_create :create_unique_identifier
  validates_presence_of :title

  def pair
    Pair.find(pair_id)
  end

  private

  def create_unique_identifier
    loop do
      self.uuid = SecureRandom.urlsafe_base64(5)
      break unless self.class.exists?(uuid: uuid)
    end
  end
end
