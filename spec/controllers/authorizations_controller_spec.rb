require 'rails_helper'

RSpec.describe AuthorizationsController do
  describe 'POST #confirm_auth' do
    context 'user already exists' do
      it 'not creates user'
    end
    context 'user does not exist' do
      it 'creates user'
    end
    it 'sends email'
  end

  describe 'GET #show' do
    context 'with correct token' do
      it 'creates authorization'
      it 'signs in user'
    end
    context 'with invalid token' do
      it 'not creates authorization'
      it 'not signs in user'
    end
  end

end
