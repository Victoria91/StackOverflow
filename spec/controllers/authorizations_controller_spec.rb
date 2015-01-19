require 'rails_helper'

RSpec.describe AuthorizationsController do
  describe 'POST #confirm_auth' do
    context 'with valid email' do
      let(:email) { build(:user).email }
      context 'user already exists' do
        let!(:user) { create(:user) }

        it 'not creates user' do
          expect { post :confirm_auth, email: user.email }.not_to change(User, :count)
        end
      end

      context 'user does not exist' do
        it 'creates user' do
          expect { post :confirm_auth, email: email }.not_to change(User, :count)
        end
      end

      it 'sets an email in session' do
        expect { post :confirm_auth, email: email }.to change { session['devise.email'] }.to(email)
      end

      it 'sends email' do
        expect { post :confirm_auth, email: email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with invalid email' do
      let(:email) { 'invalid email' }

      it 'renders form' do
        post :confirm_auth, user: { email: email }
        expect(response).to render_template 'authorizations/new'
      end

      it 'does not sends email' do
        expect { post :confirm_auth, user: { email: email } }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    before do
      session['devise.token'] = 'token'
      session['devise.email'] = user.email
      session['devise.provider_data'] =  OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'newuser@mail.com', image: 'http://provider.com/picture' })
    end

    context 'with correct token' do
      it 'creates authorization' do
        expect(User).to receive(:find_for_oauth).and_call_original
        get :show, token: session['devise.token']
      end

      it 'signs in user' do
        expect { get :show, token: session['devise.token'] }.to change { controller.current_user }.to(user)
      end
    end

    context 'with invalid token' do
      it 'not creates authorization' do
        expect(User).not_to receive(:find_for_oauth)
        get :show, token: 'invalid token'
      end

      it 'not signs in user' do
        expect { get :show, token: 'invalid token' }.not_to change { controller.current_user }
      end
    end

  end

end
