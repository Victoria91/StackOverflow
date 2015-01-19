require 'rails_helper'

RSpec.describe VotesController do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:unauthorized_status) { 401 }

  describe 'POST #vote_up' do
    let(:request) { post :vote_up, answer_id: answer, format: :js }
    it_behaves_like 'Authentication-requireable'

    context 'calls a voke_up method' do
      sign_in_user

      it 'for an answer' do
        allow(Answer).to receive(:find) { answer }
        expect(answer).to receive(:vote_up).with(@user)
        post :vote_up, answer_id: answer, format: :js
      end

      it 'for a question' do
        allow(Question).to receive(:find) { question }
        expect(question).to receive(:vote_up).with(@user)
        post :vote_up, question_id: question, format: :js
      end
    end
  end

  describe 'POST #vote_down' do
    let(:request) { post :vote_down, answer_id: answer, type: 'up', format: :js }
    it_behaves_like 'Authentication-requireable'

    context 'calls a voke_down method' do
      sign_in_user

      it 'for an answer' do
        allow(Answer).to receive(:find) { answer }
        expect(answer).to receive(:vote_down).with(@user)
        post :vote_down, answer_id: answer, format: :js
      end

      it 'for a question' do
        allow(Question).to receive(:find) { question }
        expect(question).to receive(:vote_down).with(@user)
        post :vote_down, question_id: question, format: :js
      end
    end
  end
end
