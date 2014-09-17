class QuestionsController < ApplicationController
	before_action :find_question, only: :show

	def new
		@question = Question.new
	end 

	def create
		@question = Question.new(question_params)

		if @question.save
			flash[:notice] = 'Your question has been saved.'
			redirect_to @question
		else
			render :new
		end
	end

	def show
	end

	private

	def question_params
		params[:question].permit(:title,:body)
	end

	def find_question
		@question = Question.find(params[:id])
	end

end
