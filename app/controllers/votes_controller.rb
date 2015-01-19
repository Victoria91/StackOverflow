class VotesController < ApplicationController
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

  private

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end
end
