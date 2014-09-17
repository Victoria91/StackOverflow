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
		subject { FactoryGirl.build(:question) }
		
		it 'creates a new Question object' do
			expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
		end

		it 'renders a show view' do
			post :create, question: FactoryGirl.attributes_for(:question) 
			expect(response).to redirect_to question_path(assigns(:question))
		end
	end

end
