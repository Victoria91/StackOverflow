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

	describe 'GET show'
		let(:answer) { FactoryGirl.create(:answer, question: question) }
		before { get :show, question_id: question, id: answer }

		it 'loads an answer' do
			expect(assigns(:answer)).to eq(answer)
		end

		it 'renders show template' do
			expect(response).to render_template :show
		end

end
