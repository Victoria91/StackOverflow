shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      send_request
      expect(response.status).to eq(401)
    end

    it 'returns 401 status if access_token is invalid' do
      send_request(access_token: '123456')
      expect(response.status).to eq(401)
    end
  end

  context 'authorized' do
    it 'returns success status if access_token is invalid' do
      send_request(access_token: access_token.token)
      expect(response.status).to eq(success_status)
    end
  end
end