class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  after_create :update_rating

  def update_rating
    vote_type == 1 ? question.vote_up : question.vote_down
  end
end
