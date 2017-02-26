class Ability
  include CanCan::Ability

  def initialize(user)
    user_permissions(user)
  end

  def user_permissions(user)
    can :manage, User, id: user.id
  end
end
