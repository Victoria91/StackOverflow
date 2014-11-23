require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'authorized' do
      sign_in_user

      context 'with valid attributes' do
        let(:answer_params) { attributes_for(:answer) }

        it 'creates a new answer related to question' do
          expect { post :create, answer: answer_params, question_id: question, format: :json }.to change(question.answers, :count).by(1)
        end

        it 'creates a new answer related to the user' do
          expect { post :create, answer: answer_params, question_id: question, format: :json }.to change(@user.answers, :count).by(1)
        end

        it 'response status is 201' do
          post :create, answer: answer_params, question_id: question, format: :json
          expect(response.status).to eq(201)
        end

        it 'publishes to answers channel' do
          # now = Time.now.utc
          # allow(Time).to receive(:now) { now }
          # answer = double(Answer, title: 'answer body')
          # answer = { id: Answer.last.try(:id).to_i + 1, body: 'answer body', question_id: question.id, created_at: Time.now, updated_at: Time.now, user_id: @user.id, accepted: false }.to_json
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", anything)
          post :create, answer: answer_params, question_id: question, format: :json
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:invalid_answer) }

        it 'does not create answer' do
          expect { post :create, answer: answer_params, question_id: question, format: :json }.not_to change(Answer, :count)
        end

        it 'response status is 422' do
          post :create, answer: answer_params, question_id: question, format: :json
          expect(response.status).to eq(422)
        end

        it 'does not publish to answers channel' do
          expect(PrivatePub).not_to receive(:publish_to)
          post :create, answer: answer_params, question_id: question, format: :json
        end
      end
    end

  end

  describe 'PATCH #update' do
    context 'authorized' do
      sign_in_user
      let(:another_user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: @user) }
      let(:another_answer) { create(:answer, question: question, user: another_user) }
      let(:new_answer) { build(:answer) }

      context 'own answer' do
        it 'updates an answer' do
          expect { patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json }.to change { answer.reload.body }.to(new_answer.body)
        end

        it 'status is success' do
          patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
          expect(response.status).to eq(204)
        end

        it 'publishes to answers channel' do
          answer.update(body: new_answer.body)
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", answer: answer.to_json)
          patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
        end
      end

      context 'another_answer' do
        it 'not updates an answer' do
          expect { patch :update, question_id: question, id: another_answer, answer: { body: new_answer.body }, format: :json }.not_to change { another_answer.body }
        end

        it 'not publishes to answers channel' do
          expect(PrivatePub).not_to receive(:publish_to)
          patch :update, question_id: question, id: another_answer, answer: { body: new_answer.body }, format: :json
        end
      end
    end

    context 'unauthorized' do
      let(:answer) { create(:answer, question: question, user: @user) }
      let(:new_answer) { build(:answer) }

      it 'not updates an answer' do
        expect { patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json }.not_to change { answer.reload.body }
      end

      it 'response status is 401' do
        patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
        expect(response.status).to eq(401)
      end

      it 'not publishes to answers channel' do
        expect(PrivatePub).not_to receive(:publish_to)
        patch :update, question_id: question, id: answer, answer: { body: new_answer.body }, format: :json
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized' do
      sign_in_user
      let!(:answer) { create(:answer, question: question, user: @user) }
      let!(:another_answer) { create(:answer, question: question, user: create(:user)) }

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
      let(:answer) { create(:answer, question: question, user: @user) }
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
        expect { post :accept, question_id: question, id: answer, format: :js }.to change { answer.reload.accepted }.to true
      end

      it 'reaccept answer' do
        accepted_answer = FactoryGirl.create(:answer, question: question, accepted: true)
        expect { post :accept, question_id: question, id: accepted_answer, format: :js }.to change { accepted_answer.reload.accepted }.to false
      end

      it 'not accepted another users question' do
        expect { post :accept, question_id: another_question, id: another_answer, format: :js }.not_to change { another_answer.reload.accepted }
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
