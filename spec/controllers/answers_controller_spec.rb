require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { FactoryGirl.create(:question) }

  describe 'POST #create' do
    context 'authorized' do
      sign_in_user

      it 'creates a new answer related to question' do
        expect { post :create, answer: FactoryGirl.attributes_for(:answer), question_id: question, format: :json }.to change(question.answers, :count).by(1)
      end

      it 'creates a new answer related to the user' do
        expect { post :create, answer: FactoryGirl.attributes_for(:answer), question_id: question, format: :json }.to change(@user.answers, :count).by(1)
      end

      it 'redirect to answer_path' do
        post :create, answer: FactoryGirl.attributes_for(:answer, question_id: question), question_id: question, format: :json
        expect(response.status).to eq(201)
      end
    end

  end

  describe 'PATCH #update' do
    context 'authorized' do
      sign_in_user
      let(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
      let(:new_answer) { FactoryGirl.build(:answer) }

      it 'updates an answer' do
        expect { patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json }.to change { answer.reload.body }.to(new_answer.body)
      end

      it 'status is success' do
        patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
        expect(response.status).to eq(204)
      end
    end

    context 'unauthorized' do
      let(:answer) { FactoryGirl.create(:answer, question: question, user: @user) }
      let(:new_answer) { FactoryGirl.build(:answer) }

      it 'updates an answer' do
        expect { patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json }.not_to change { answer.reload.body }
      end

      it 'renders update template' do
        patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
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
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'NOT deletes another answer' do
        expect { delete :destroy, question_id: question, id: another_answer, format: :js }.not_to change(question.answers, :count)
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
        expect { delete :destroy, question_id: question, id: answer, format: :js }.not_to change(question.answers, :count)
      end

      it 'responses 401 status' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response.status).to eq(401)
      end

    end
  end

  describe 'POST #accept' do
    context 'authorized' do
      sign_in_user
      let!(:question) { FactoryGirl.create(:question, user: @user) }
      let(:another_question) { FactoryGirl.create(:question, user: FactoryGirl.create(:user)) }
      let!(:answer) { FactoryGirl.create(:answer, question: question) }
      let(:another_answer) { FactoryGirl.create(:answer, question: another_question) }

      it 'accepts answer' do
        puts answer.accepted
        expect { post :accept, question_id: question, id: answer, format: :js }.to change { answer.reload.accepted }.to true
        puts answer.reload.accepted
      end

      it 'reaccept answer' do
        accepted_answer = FactoryGirl.create(:answer, question: question, accepted: true)
        expect { post :accept, question_id: question, id: accepted_answer, format: :js }.to change { accepted_answer.reload.accepted }.to false
      end

      it 'not accepted another users question' do
        expect { post :accept, question_id: another_question, id: another_answer, format: :js }.not_to change { answer.reload.accepted }
      end

    end

    context 'unauthorized' do
      let(:question) { FactoryGirl.create(:question, user: FactoryGirl.create(:user)) }
      let(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'not changes accepted state' do
        expect { post :accept, question_id: question, id: answer, format: :js }.not_to change(answer.reload, :accepted)
      end

    end
  end

end
