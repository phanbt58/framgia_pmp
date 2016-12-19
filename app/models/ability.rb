class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
      can :read, [Project, Sprint, WorkPerformance]
      can [:create, :update], WorkPerformance, user_id: user.id

      cannot [:update], Sprint do |sprint|
        sprint.project.close?
      end
      cannot [:create, :update, :destroy], ProductBacklog,
        project: {status: 3}
      cannot [:create, :update], WorkPerformance do |wpd|
        wpd.sprint && wpd.sprint.project.close?
      end
    elsif user.manager?
      can :manage, [Sprint, User, WorkPerformance, Phase]
      can :manage, ProductBacklog
      can [:read, :create, :destroy], Project
      can [:update], Project, Project.is_not_closed

      cannot [:create, :update, :destroy], Sprint do |sprint|
        sprint.project.close?
      end
      cannot [:create, :update, :destroy], ProductBacklog do |backlog|
        backlog.project.close?
      end
      cannot [:create, :update, :destroy], WorkPerformance do |wpd|
        wpd.sprint && wpd.sprint.project.close?
      end
      cannot [:update], Project, Project.close
    end
  end
end
