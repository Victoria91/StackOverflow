require 'rails_helper' 

describe 'Answers API' do
  describe 'GET/index' do
    let(:question) { create(:question) }
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end
    end

  end
end