class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = @question.answers.new(params.require(:answer).permit(:body))
    @answer.user = current_resource_owner
    @answer.save
    respond_with @question, @answer
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end