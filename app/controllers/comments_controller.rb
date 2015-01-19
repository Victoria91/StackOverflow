class CommentsController < ApplicationController
  include Concernable

  before_action :authenticate_user!
  before_action :load_parent

  respond_to :js

  authorize_resource

  def create
    respond_with @comment = @parent.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
