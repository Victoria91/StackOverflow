class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent

  respond_to :js

  authorize_resource

  def vote_up
    current_user.votes.create(voteable: @parent, vote_type: '+1')
  end

  def vote_down

  end

  private

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end
end
