class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :validatable
          # , :confirmable TODO: Add when ready with a URL on frontend
  include DeviseTokenAuth::Concerns::User
  has_and_belongs_to_many :roles
  has_many :quizzes

  has_many :groups_users, dependent: :delete_all
  has_many :groups, -> { distinct }, through: :groups_users

  validates_presence_of :name, :email
  validates :email, uniqueness: true

  after_create :check_invites

  def student?
    has_role?(:student)
  end

  private

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def check_invites
    GroupInvite.where(email: email).each do |invite|
      invite.group.users << self
      invite.destroy
    end
  end
end
