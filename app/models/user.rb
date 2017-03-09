class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :validatable
          # , :confirmable TODO: Add when ready with a URL on frontend
  include DeviseTokenAuth::Concerns::User
  has_and_belongs_to_many :roles
  has_many :quizzes

  has_many :groups_users, dependent: :delete_all
  has_many :groups_in, -> { distinct }, through: :groups_users, source: :group
  has_many :groups

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
