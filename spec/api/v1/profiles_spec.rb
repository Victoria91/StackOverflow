require 'rails_helper'

describe 'Profile API' do
  let(:success_status) { 200 }

  describe 'GET/me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like 'API authenticable'

    before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

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

    def send_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET/users' do
    let!(:users) { create_list(:user, 5) }
    let(:access_token) { create(:access_token, resource_owner_id: users.last.id) }

    it_behaves_like 'API authenticable'

    before { get '/api/v1/profiles/users', format: :json, access_token: access_token.token }

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

    def send_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end
end
