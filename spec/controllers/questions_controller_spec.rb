require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
	describe 'GET #new' do
		context 'authorized' do
			sign_in_user
			before { get :new }

			it 'loads a new Question object' do
				expect(assigns(:question)).to be_a_new(Question)
			end

			it 'render a new view' do
				expect(response).to render_template :new
			end

			it 'loads attachment' do 
				expect(assigns(:question).attachments.first).to be_a_new(Attachment)
			end
		end

		context 'unauthorized' do
			it 'redirects' do
				get :new
				expect(response).to be_redirect
			end
		end
	end

	describe 'POST #create' do
		sign_in_user

		context 'with valid attributes' do
			it 'creates a new Question object' do
				expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(@user.questions, :count).by(1)
			end

			it 'redirects to show a question' do
				post :create, question: FactoryGirl.attributes_for(:question) 
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			it 'not creates a new Question object' do
				expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to_not change(Question, :count)
			end

			it 'renders a new view' do
				post :create, question: FactoryGirl.attributes_for(:invalid_question) 
				expect(response).to render_template :new
			end
		end
	end

	describe 'GET #show' do
		subject { FactoryGirl.create(:question) }
		before { get :show, id: subject }

		it 'loads a Question object' do
			expect(assigns(:question)).to eq(subject)
		end

		it 'loads a new Answer object' do
			expect(assigns(:answer)).to be_a_new(Answer)
		end

		it 'renders show view' do
			expect(response).to render_template :show
		end
	end

	describe 'GET #index' do
		let(:questions) { FactoryGirl.create_list(:question, 2) }
		before { get :index }

		it 'loads questions to an array' do
			expect(assigns(:questions)).to match_array(questions)
		end

		it 'renders index view' do
			expect(response).to render_template :index
		end

	end

	describe 'DELETE #destroy' do
		sign_in_user

		context 'own question' do
			let(:question) { FactoryGirl.create(:question, user: @user) }
			before { question }

			it 'deletes a question' do
				expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
			end

			it 'redirects to root path' do
				delete :destroy, id: question
				expect(response).to redirect_to root_path
			end

		end

		context 'another question' do
			let(:another_user) { FactoryGirl.create(:user) }
			let(:another_question) { FactoryGirl.create(:question, user: another_user) }
			before { another_question }

			it 'deletes a question' do
				expect{ delete :destroy, id: another_question }.not_to change(Question, :count)
			end

			it 'redirects to root path' do
				delete :destroy, id: another_question
				expect(response).to redirect_to question_path(another_question)
			end

		end
	end

	describe 'PATCH #update' do
		context 'authorized' do
			sign_in_user
			let(:question) { FactoryGirl.create(:question, user: @user) }
			let(:another_user) { FactoryGirl.create(:user) }
			let(:another_question) { FactoryGirl.create(:question, user: another_user) }

			context 'own question' do
				it 'updates a question object' do
					expect{ patch :update, id: question, question: {body: 'new body'}, format: :js}.to change{ question.reload.body }.to 'new body'
				end
			end

			context 'someone elses question' do
				it 'NOT updates a question object' do
					expect{ patch :update, id: another_question, question: {body: 'new bod45454y'}, format: :js}.not_to change{ another_question.reload.body }
					expect(response.status).to eq(200)
				end
			end

			it 'renders update template' do
				patch :update, id: question, question: {body: 'new body'}, format: :js
				expect(response).to render_template :update
			end

		end

		context 'unauthorized' do
			let(:question) { FactoryGirl.create(:question, user: @user) }

			it 'not updates a question object' do
				expect{ patch :update, id: question, question: {body: 'new body'}, format: :js}.not_to change{question.reload.body}
			end

		end
	end

end
