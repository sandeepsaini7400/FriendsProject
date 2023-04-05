class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 
    can :read, Friend, public: true
    if user.present?
      if user.admin?
        can :manage, Friend
        can :manage, :all
      else 
        can :read, Friend
        cannot :read, Friend, hidden: true
      end
    else
      can :read, :sign_up
    end
  end
                    # def initialize(user)
                    #   user ||= User.new
                    #   if user.present?
                    #     # if user.admin?
                    #     if user.role == 'admin'
                    #       can :manage, :all 
                    #     else
                    #       can :read, :friends
                    #     end
                    #   end
                    # end
end

