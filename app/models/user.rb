class User < ApplicationRecord
  has_secure_password
  has_many :assignments
  has_and_belongs_to_many :roles

  validates_presence_of :name, :email

  def student?
    has_role?(:student)
  end

  private

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
end
