class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
      can :read, [Project, WorkPerformance, ProductBacklog, Sprint]
    elsif user.manager?
      can :read, [Sprint, WorkPerformance]
      can :manage, [User, Phase, Project]
    end

    user.projects.each do |project|
      project_member = project.members.find_by user: user
      next if project[:status] >= 2

      if project_member.manager?
        can [:read, :update], Project
        can [:create, :update, :destroy], [Sprint, WorkPerformance]
        can [:create, :update, :destroy], ProductBacklog
      else
        can [:create, :update], WorkPerformance, task: {user_id: user.id},
          sprint: {id: user.sprints.map(&:id)}
        can [:update], Sprint, id: user.sprints.map(&:id)
        cannot :edit, Sprint
      end
    end
  end
end
