class VotesController < ApplicationController
  include Concernable

  before_action :authenticate_user!
  before_action :load_parent

  respond_to :js

  def vote_up
    authorize! :vote_up, @parent
    @parent.vote_up(current_user)
    render 'vote'
  end

  def vote_down
    authorize! :vote_down, @parent
    @parent.vote_down(current_user)
    render 'vote'
  end
end
