require 'rails_helper'

RSpec.describe ProfilesController do
  describe 'GET #digest_unsubscribe' do
    context 'authorized' do
      sign_in_user

      it 'changes digest state' do
        puts @user.digest
        expect { get :digest_unsubscribe }.to change { @user.reload.digest }.to(false)
      end 
    end

    context 'unauthorized' do
      it 'redirects' do
        get :digest_unsubscribe
        expect(response).to be_redirect
      end
    end
  end

end
