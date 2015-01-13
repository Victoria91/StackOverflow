class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  after_create :update_rating

  def update_rating
    vote_type == 1 ? voteable.vote_up : voteable.vote_down
  end
end
