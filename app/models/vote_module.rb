module VoteStaff
  def vote_up
    update(rating: rating + 1)
  end

  def vote_down
    update(rating: rating - 1)
  end
end
