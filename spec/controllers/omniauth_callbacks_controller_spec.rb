require 'rails_helper'

RSpec.describe OmniauthCallbacksController do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'provider does not return an email' do
    context 'user with an authorization exists' do
      let(:provider) { :twitter }

      it_behaves_like 'Provider returning email'
    end

    context 'user with an authorization does not exist' do
      before do
        stub_env_for_omniauth
        get :twitter
      end

      it 'sets data from provider to session' do
        expect(session['devise.provider_data']).to eq(stub_env_for_omniauth)
      end

      it 'redirects to authorizations_new_path' do
        expect(response).to redirect_to(authorizations_new_path)
      end
    end

    def stub_env_for_omniauth
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        'provider' => 'twitter',
        'uid' => '123456',
        'info' => {
          'name' => 'mockuser',
          'image' => 'mock_user_thumbnail_url'
        }
      )
    end
  end

  context 'provider returns an email' do
    let(:user) { create(:user) }

    describe '#facebook' do
      let(:provider) { :facebook }

      it_behaves_like 'Provider returning email'
    end

    describe '#vkontakte' do
      let(:provider) { :vkontakte }

      it_behaves_like 'Provider returning email'
    end

    def stub_env_for_omniauth
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        'provider' => 'facebook',
        'uid' => '123456',
        'info' => {
          'name' => 'mockuser',
          'image' => 'mock_user_thumbnail_url',
          'email' => 'mail@mail.ru'
        }
      )
    end
  end

end
