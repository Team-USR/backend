class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :groups

  validates_presence_of :name, :email
  validates :email, uniqueness: true

  def student?
    has_role?(:student)
  end

  private

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
end
