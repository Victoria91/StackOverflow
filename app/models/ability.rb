class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, to: :vote

    if user
      can :create, [Question, Answer, Comment]
      can [:update, :create, :destroy], [Question, Answer], user: user
      can :accept, Answer, question: { user: user }
      can :vote, [Question, Answer] do |obj|
        obj.votes.where(user: user).empty? && obj.user != user
      end
      can [:me, :users], :profile
      can :subscribe, Question do |q|
        q.user != user && q.subscriptions.where(user: user).empty?
      end
      can :unsubscribe, Question do |q|
        q.subscriptions.where(user: user).present?
      end
      can :cancel_notifications, Question do |q|
        q.notifications && q.user == user
      end
    end

    can :read, :all
  end
end
