class Api::V1::QuestionsController < Api::V1::BaseController
  
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    @question = Question.new(params.require(:question).permit(:body, :title))
    @question.user = current_resource_owner
    @question.save
    respond_with @question
  end

end