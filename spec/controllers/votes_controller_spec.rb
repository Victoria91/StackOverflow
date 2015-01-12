require 'rails_helper'

RSpec.describe VotesController do
  let(:answer) { create(:answer, question: create(:question)) }
  let(:unauthorized_status) { 401 }

  describe 'POST #vote_up' do 
    it_behaves_like 'Authentication-requireable'
    
    sign_in_user

    it 'creates a vote' do
      expect{ post :vote_up, answer_id: answer }.to change{ @user.votes.where(vote_type: '+1').count }.by(1)
    end
  end

  describe 'POST #vote_down' do
    it_behaves_like 'Authentication-requireable'

    it 'creates vote'
  end
end
