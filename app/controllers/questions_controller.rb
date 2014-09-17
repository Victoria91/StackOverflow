class QuestionsController < ApplicationController
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

	private

	def question_params
		params[:question].permit(:title,:body)
	end

end
