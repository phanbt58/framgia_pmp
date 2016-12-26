class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
      can :read, [Project, WorkPerformance, ProductBacklog, Sprint]

      user.projects.each do |project|
        next if project.close?
        can [:create, :update], WorkPerformance, task: {user_id: user.id},
          sprint: {id: user.sprints.map(&:id)}
        can [:update], Sprint, id: user.sprints.map(&:id)
      end
    elsif user.manager?
      can [:read, :create, :destroy], Project
      can :read, [Sprint, WorkPerformance]
      can :manage, [User, Phase]

      user.projects.each do |project|
        next if project.close?
        can :update, Project
        can [:create, :update, :destroy], [Sprint, WorkPerformance]
        can [:create, :update, :destroy], ProductBacklog
      end
    end
  end
end
