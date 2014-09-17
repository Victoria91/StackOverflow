class AnswersController < ApplicationController
	before_filter :find_answer, only: :show

	def new
		@question = Question.find(params[:question_id])
		@answer = @question.answers.new
	end

	def create
		@question = Question.find(params[:question_id])
		@answer = @question.answers.new(answer_params)

		if @answer.save
			flash[:notice] = 'Your answer has been saved'
      redirect_to question_answer_path(@question,@answer)
		else
			render :new
		end
	end

	def show
	end

	private
	
	def answer_params
		params.require(:answer).permit(:question_id, :body)
	end

	def find_answer
		@answer = Answer.find(params[:id])
	end
end
