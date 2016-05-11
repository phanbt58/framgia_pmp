class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.manager? || user.leader?
      can :manage, Project 
    end
  end
end
