require 'rails_helper'

RSpec.describe ProfilesController do
  describe 'GET #digest_unsubscribe' do
    context 'authorized' do
      sign_in_user

      it 'changes digest state' do
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

  describe 'GET #index' do
    context 'authorized' do
      sign_in_user

      it 'loads current_user to a @user variable' do
        get :show
        expect(assigns(:user)).to eq(@user)
      end
    end

    context 'unauthorized' do
      let(:request) { get :show }
      let(:unauthorized_status) { 302 }

      it_behaves_like 'Authentication-requireable'
    end
  end

end
