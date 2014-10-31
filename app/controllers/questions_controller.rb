class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :find_question, only: [:show, :destroy, :update]
  after_action :publish_to_questions_chanel, only: :create

  respond_to :html, :js, :json

  authorize_resource

  def new
    respond_with(@question = Question.new)
  end

  def index
    respond_with(@questions = Question.all)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    flash[:notice] = 'Your question has been saved.' if @question.save
    respond_with(@question)
  end

  def show
    @answer = @question.answers.build
    respond_with @question
  end

  def destroy
    flash[:notice] = 'Your question has been deleted'
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  private

  def question_params
    params[:question].permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def publish_to_questions_chanel
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.save
  end
end
