require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
	let(:question) { FactoryGirl.create(:question) }


	describe 'GET #new' do
		before { get :new, question_id: question }

		it 'loads a new Answer object' do
			expect(assigns(:answer)).to be_a_new(Answer)
		end

		it 'new answer is associated with an incoming question' do
		end

		it 'renders new template' do
			expect(response).to render_template :new
		end
	end

	describe 'POST #create' do
		it 'creates a new Answer' do
			expect{ post :create, answer: FactoryGirl.attributes_for(:answer), question_id: question }.to change(Answer, :count).by(1)
		end

		it 'redirect to answer_path' do
			post :create, answer: FactoryGirl.attributes_for(:answer, question_id: question), question_id: question
			expect(response).to redirect_to question_answer_path(question,assigns(:answer))
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
