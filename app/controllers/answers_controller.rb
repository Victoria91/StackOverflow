class AnswersController < ApplicationController
	before_action :find_answer, only: [:show, :update]
	before_action :find_question, :authenticate_user!, only: [:new, :create, :update]

	def create
		@answer = @question.answers.new(answer_params)
		@answer.user = current_user
		@answer.save
	end

	def show
	end

	def update
		@answer.update(answer_params)
	end

	private
	
	def answer_params
		params.require(:answer).permit(:body)
	end

	def find_answer
		@answer = Answer.find(params[:id])
	end

	def find_question
		@question = Question.find(params[:question_id])
	end
end
