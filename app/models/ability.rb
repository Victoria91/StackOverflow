class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    if user
      can :create, :all
      can :manage, Question, user: user
      can :update, Answer, user: user 
      can :create, Answer, user: user 
      can :destroy, Answer, user: user
    end
    
    can :read, :all
  end
end
