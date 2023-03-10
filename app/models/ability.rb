class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 
    case user.is?
    when 'author'
      can :manage , Friend
    else
      can :read, Friend
    end
  end
end
