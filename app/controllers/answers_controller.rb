class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, except: :create
  after_action :publish_to_question_answer_channel, only: [:create, :update]

  respond_to :js, only: [:destroy, :accept]
  respond_to :json, only: [:create, :update]

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy
  end

  def accept
    @answer.toggle_accepted
  end

  private

  def publish_to_question_answer_channel
    PrivatePub.publish_to "/questions/#{@answer.question.id}/answers", answer: @answer.to_json if @answer.valid?
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
