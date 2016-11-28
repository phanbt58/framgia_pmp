class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
      can :read, Project
      can :read, WorkPerformance
      can [:create, :update], WorkPerformance, user_id: user.id
      can :read, Sprint
    elsif user.manager?
      can :manage, Project
      can :manage, Sprint
      can :manage, User
      can :manage, WorkPerformance
      can :manage, Phase
      can [:update], User
      can :manage, ProductBacklog
    end
  end
end
