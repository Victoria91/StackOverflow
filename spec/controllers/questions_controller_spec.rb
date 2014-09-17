require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
	describe 'GET #new' do
		before { get :new }

		it 'loads a new Question object' do
			expect(assigns(:question)).to be_a_new(Question)
		end

		it 'render a new view' do
			expect(response).to render_template :new
		end
	end

	describe 'POST #create' do
		context 'with valid attributes' do
			it 'creates a new Question object' do
				expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
			end

			it 'redirects to show a question' do
				post :create, question: FactoryGirl.attributes_for(:question) 
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			it 'not creates a new Question object' do
				expect { post :create, question: FactoryGirl.attributes_for(:question, body: nil) }.to_not change(Question, :count)
			end

			it 'renders a new view' do
				post :create, question: FactoryGirl.attributes_for(:question, body: nil) 
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

		it 'renders show view' do
			expect(response).to render_template :show
		end
	end

end