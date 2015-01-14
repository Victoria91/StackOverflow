require 'rails_helper'

RSpec.describe VotesController do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:unauthorized_status) { 401 }

  describe 'POST #vote_up' do
    let(:request) { post :vote_up, answer_id: answer, format: :js }
    it_behaves_like 'Authentication-requireable'

    context 'authorized creates a vote' do
      sign_in_user

      it 'for an answer' do
        # expect(answer).to receive(:vote_up).with(@user) // doesn't work for some reason, even with let!
        expect{ post :vote_up, answer_id: answer, format: :js }.to change{ @user.votes.where(vote_type: '+1', voteable: answer).count }.by(1)
      end

      it 'for a question' do
        expect{ post :vote_up, question_id: question, format: :js }.to change{ @user.votes.where(vote_type: '+1', voteable: question).count }.by(1)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:request) { post :vote_down, answer_id: answer, type: 'up', format: :js }
    it_behaves_like 'Authentication-requireable'

    context 'authorized creates a vote' do
      sign_in_user

      it 'for an answer' do
        expect{ post :vote_down, answer_id: answer, format: :js }.to change { @user.votes.where(vote_type: '-1').count }.by(1)
      end

      it 'for a question' do
        expect{ post :vote_down, question_id: question, format: :js }.to change { @user.votes.where(vote_type: '-1').count }.by(1)
      end
    end
  end
end
