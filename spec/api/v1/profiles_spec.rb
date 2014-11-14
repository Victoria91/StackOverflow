require 'rails_helper'

describe 'Profile API' do
  describe 'GET/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '12412412424'
        expect(response.status).to eq(401)
      end

    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      %w(email id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET/users' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/users', format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/users', format: :json, access_token: '12412412424'
        expect(response.status).to eq(401)
      end

    end

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: users.last.id) }

      before { get '/api/v1/profiles/users', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'returns list of users' do
        expect(response.body).to have_json_size(users.length - 1).at_path('profiles')
      end

      %w(email id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(users.first.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end
      end

      it 'does not return an authorized user' do
        expect(assigns(:users)).not_to include(users.last)
      end
    end
  end
end
