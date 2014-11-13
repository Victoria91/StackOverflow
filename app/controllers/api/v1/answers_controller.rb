class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = Question.find(params[:question_id]).answers
    respond_with @answers
  end

end