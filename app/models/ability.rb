class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, to: :vote

    if user
      can :create, [Question, Answer]
      can [:update, :create, :destroy], [Question, Answer], user: user
      can :accept, Answer, question: { user: user }
      can :vote, Question do |q|
        q.votes.where(user: user).empty? && q.user != user
      end
      can [:me, :users], :profile
    end

    can :read, :all
  end
end
