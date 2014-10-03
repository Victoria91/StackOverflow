require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
	let(:question) { FactoryGirl.create(:question) }

	describe 'POST #create' do
		context 'authorized' do
			sign_in_user

			it 'creates a new answer related to question' do
				expect{ post :create, answer: FactoryGirl.attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
			end

			it 'creates a new answer related to the user' do
				expect{ post :create, answer: FactoryGirl.attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
			end

			it 'redirect to answer_path' do
				post :create, answer: FactoryGirl.attributes_for(:answer, question_id: question), question_id: question, format: :js
				expect(response).to render_template :create
			end
		end

	end

	describe 'PATCH #update' do
		context 'authorized' do
			sign_in_user
			let(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
			let(:new_answer) { FactoryGirl.build(:answer) }

			it 'updates an answer' do
				expect{ patch :update, question_id: question, id: answer, answer: {body: new_answer.body}, format: :js}.to change{ answer.reload.body}.to(new_answer.body)
			end

			it 'renders update template' do
				patch :update, question_id: question, id: answer, answer: {body: new_answer.body}, format: :js
				expect(response).to render_template :update
			end
		end

		context 'unauthorized' do
			let(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
			let(:new_answer) { FactoryGirl.build(:answer) }

			it 'updates an answer' do
				expect{ patch :update, question_id: question, id: answer, answer: {body: new_answer.body}, format: :js}.not_to change{ answer.reload.body}
			end

			it 'renders update template' do
				patch :update, question_id: question, id: answer, answer: {body: new_answer.body}, format: :js
				expect(response.status).to eq(401)
			end
		end
	end

	describe 'DELETE #destroy' do
		

		context 'authorized' do
			sign_in_user
			let!(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
			let!(:another_answer) { FactoryGirl.create(:answer, question: question, user: FactoryGirl.create(:user)) }

			it 'deletes own answer' do
				expect{ delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
			end

			it 'NOT deletes another answer' do
				expect{ delete :destroy, question_id: question, id: another_answer, format: :js }.not_to change(question.answers, :count)
			end
			
			it 'renders destroy view' do
				delete :destroy, question_id: question, id: answer, format: :js
				render_template :destroy
			end
		end

		context 'unauthorized' do
			let(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
			before { answer }

			it 'not deletes answer object' do
				expect{ delete :destroy, question_id: question, id: answer, format: :js }.not_to change(question.answers, :count)
			end

			it 'responses 401 status' do
				delete :destroy, question_id: question, id: answer, format: :js 
				expect(response.status).to eq(401)
			end

		end
	end

end
