class QuestionsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
	before_action :find_question, only: [:show, :destroy, :update]

	def new
		@question = Question.new
	end 

	def index
		@questions = Question.all
	end

	def create
		@question = Question.new(question_params)
		@question.user = current_user

		if @question.save
			flash[:notice] = 'Your question has been saved.'
			redirect_to @question
		else
			render :new
		end
	end

	def show
		@answer = @question.answers.build
	end

	def destroy
		if @question.user == current_user
			@question.destroy
			flash[:notice] = 'Your question has been deleted'
			redirect_to root_path
		else
			flash[:notice] = 'Only owner can delete question'	
			redirect_to question_path(@question)
		end
	end

	def update
		@question.update(question_params) if @question.user == current_user
	end

	private

	def question_params
		params[:question].permit(:title,:body, attachments_attributes: [:file, :id, :_destroy])
	end

	def find_question
		@question = Question.find(params[:id])
	end

end
