class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent

  respond_to :js

  authorize_resource

  def create
    respond_with @comment = @parent.comments.create(comment_params.merge(user: current_user))
  end

  private

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end 

  def comment_params
    params.require(:comment).permit(:body)
  end
end
