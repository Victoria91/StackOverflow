require 'rails_helper'

RSpec.describe VotesController do
  let(:answer) { create(:answer, question: create(:question)) }
  let(:unauthorized_status) { 401 }

  describe 'POST #vote_up' do
    let(:request) { post :vote_up, answer_id: answer, type: 'up', format: :js }
    it_behaves_like 'Authentication-requireable'
    
    context 'authorized' do
      sign_in_user

      it 'creates a vote' do
        expect{ post :vote_up, answer_id: answer, type: 'up', format: :js }.to change{ @user.votes.where(vote_type: '+1').count }.by(1)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:request) { post :vote_down, answer_id: answer, type: 'up', format: :js }
    it_behaves_like 'Authentication-requireable'

    context 'authorized' do
      sign_in_user

      it 'creates vote' do
        expect{ post :vote_down, answer_id: answer, type: 'up', format: :js }.to change{ @user.votes.where(vote_type: '-1').count }.by(1)
      end
    end
  end
end
