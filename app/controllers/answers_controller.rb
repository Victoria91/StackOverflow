class AnswersController < ApplicationController
	before_action :find_answer, only: :show
	before_action :find_question, :authenticate_user!, only: [:new, :create]


	def create
		@question.answers.create(answer_params)
	end

	def show
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
