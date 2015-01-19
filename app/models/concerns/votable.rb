module Votable
  extend ActiveSupport::Concern

  def vote_up(user)
    update(rating: rating + 1)
    votes.create(vote_type: '+1', user: user)
  end

  def vote_down(user)
    update(rating: rating - 1)
    votes.create(vote_type: '-1', user: user)
  end
end
