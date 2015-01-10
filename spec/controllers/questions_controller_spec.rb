require 'rails_helper'

RSpec.describe QuestionsController do
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
      let(:question_params) { attributes_for(:question) }

      it 'creates a new Question object' do
        expect { post :create, question: question_params }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show a question' do
        post :create, question: question_params
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'publishes to questions channel' do
        question = create(:question, user: @user)
        allow(Question).to receive(:new) { question }
        expect(PrivatePub).to receive(:publish_to).with('/questions', question: question.to_json)
        post :create, question: question_params
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:invalid_question) }

      it 'not creates a new Question object' do
        expect { post :create, question: question_params }.to_not change(Question, :count)
      end

      it 'renders a new view' do
        post :create, question: question_params
        expect(response).to render_template :new
      end

      it 'not publishes to questions channel' do
        expect(PrivatePub).not_to receive(:publish_to)
        post :create, question: question_params
      end
    end
  end

  describe 'GET #show' do
    subject { create(:question) }
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
    let!(:questions) { create_list(:question, 5) }

    context 'no tags required' do
      before { get :index }

      it 'loads questions to an array' do
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    context 'tags required' do
      let(:tag) { create(:tag) }
      
      it 'returns questions with the required tag' do
        tag.questions << questions.last(2)
        get :index, tag: tag.name
        expect(assigns(:questions)).to eq(tag.questions)
      end

      it 'renders index template' do
        get :index, tag: tag.name
        expect(response).to render_template :index
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'own question' do
      let(:question) { create(:question, user: @user) }
      before { question }

      it 'deletes a question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirects to root path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end

    end

    context 'another question' do
      let(:another_user) { create(:user) }
      let!(:another_question) { create(:question, user: another_user) }

      it 'deletes a question' do
        expect { delete :destroy, id: another_question }.not_to change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'authorized' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user) }

      context 'own question' do
        it 'updates a question object' do
          expect { patch :update, id: question, question: { body: 'new question body' }, format: :js }.to change { question.reload.body }.to 'new question body'
        end
      end

      context 'someone elses question' do
        it 'NOT updates a question object' do
          expect { patch :update, id: another_question, question: { body: 'new bod45454y' }, format: :js }.not_to change { another_question.reload.body }
        end
      end

      it 'renders update template' do
        patch :update, id: question, question: { body: 'new body' }, format: :js
        expect(response).to render_template :update
      end

    end

    context 'unauthorized' do
      let(:question) { create(:question, user: create(:user)) }

      it 'not updates a question object' do
        expect { patch :update, id: question, question: { body: 'new body' }, format: :js }.not_to change { question.reload.body }
      end

    end
  end

  describe 'POST #vote_up' do
    let(:question) { create(:question, user: create(:user)) }

    context 'authorized' do
      sign_in_user
      it 'increases vote rating on own question' do
        expect { post :vote_up, id: question, format: :js }.to change { question.reload.rating }.by(1)
      end

      it 'not increases vote rating on another_question question' do
        expect { post :vote_up, id: create(:question, user: @user), format: :js }.not_to change { question.reload.rating }
      end

      it 'creates a new user vote on question with value up' do
        expect { post :vote_up, id: question, format: :js }.to change { @user.votes.where(vote_type: '+1').count }.by(1)
      end
    end

    context 'unauthorized' do
      it 'not changes question rating' do
        expect { post :vote_up, id: question, format: :js }.not_to change { question.reload.rating }
      end
    end
  end

  describe 'POST #vote_down' do
    let(:question) { create(:question, user: create(:user)) }

    context 'authorized' do
      sign_in_user
      it 'decreases vote rating on own question' do
        expect { post :vote_down, id: question, format: :js }.to change { question.reload.rating }.by(-1)
      end

      it 'not decreases vote rating on another_question question' do
        expect { post :vote_down, id: create(:question, user: @user), format: :js }.not_to change { question.reload.rating }
      end

      it 'creates a new user vote on question with value down' do
        expect { post :vote_down, id: question, format: :js }.to change { @user.votes.where(vote_type: '-1').count }.by(1)
      end
    end

    context 'unauthorized' do
      it 'not changes question rating' do
        expect { post :vote_down, id: question, format: :js }.not_to change { question.reload.rating }
      end
    end
  end

  describe 'POST #subscribe' do
    sign_in_user
    let(:question) { create(:question, user: create(:user)) }

    it 'creates subscription' do
      expect { post :subscribe, id: question, format: :js }.to change(@user.subscriptions.where(question: question), :count).by(1)
    end

    it 'not creates a subscription if it already exists' do
      create(:subscription, user: @user, question: question)
      expect { post :subscribe, id: question, format: :js }.not_to change(@user.subscriptions.where(question: question), :count)
    end
  end

  describe 'DELETE #unsubscribe' do
    sign_in_user
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, question: question, user: @user) }

    it 'deletes subscription' do
      expect { delete :unsubscribe, id: question, format: :js }.to change(@user.subscriptions.where(question: question), :count).by(-1)
    end
  end

  describe 'GET #cancel_notifications' do

    context 'authorized' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      let(:another_question) { create(:question, user: create(:user)) }

      it 'redirects to a question_path' do
        get :cancel_notifications, id: question
        expect(response).to redirect_to question_path(question)
      end

      it 'changes notifications state' do
        expect { get :cancel_notifications, id: question }.to change { question.reload.notifications }.to(false)
      end

      it 'not changes notifications state for another question' do
        expect { get :cancel_notifications, id: another_question }.not_to change { question.reload.notifications }
      end
    end

    context 'unauthorized' do
      let(:question) { create(:question, user: create(:user)) }

      it 'not changes notifications state' do
        expect { get :cancel_notifications, id: question }.not_to change { question.reload.notifications }
      end
    end

  end

end
