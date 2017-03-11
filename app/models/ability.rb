class Ability
  include CanCan::Ability

  def initialize(user)
    user_permissions(user)
    quiz_permissions(user)
    groups_permissions(user)
  end

  def user_permissions(user)
    can :manage, User, id: user.id
  end

  def quiz_permissions(user)
    can :manage, Quiz, user_id: user.id
  end

  def groups_permissions(user)
    can :manage, Group do |group|
      group.admins.include?(user)
    end

    can :display, Group do |group|
      group.users.include?(user)
    end
  end
end
