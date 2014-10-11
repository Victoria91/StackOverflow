class AnswersController < ApplicationController
	before_action :authenticate_user!
	before_action :find_question
	before_action :find_answer, except: :create

	def create
		@answer = @question.answers.new(answer_params)
		@answer.user = current_user
		respond_to do |format|
			if @answer.save
				format.json { render json: @answer }
			else
				format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @answer.update(answer_params)
				format.json { render json: @answer }
			else
				format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@answer.destroy if @answer.user == current_user
	end

	def accept
		@answer.toggle_accepted if @question.user == current_user
	end

	private
	
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
