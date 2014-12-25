require 'rails_helper'

RSpec.describe OmniauthCallbacksController do

  describe 'POST #create_user' do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user with email alredy exists' do
      let!(:user) { create(:user) }

      # {}"user"=>{"email"=>"vi4ka_91@mail.ru", "authorizations_attributes"=>{"0"=>{"uid"=>"2846765163", "provider"=>"twitter"}}},
      xit 'does not create user' do
        expect { post :create_user, "user"=>{"email" => user.email, "authorizations_attributes"=>{"0"=>{"uid"=>"2846765163", "provider"=>"twitter"}}} }.not_to change(User, :count)
      end

      xit 'creates authorization' do
        expect { post :create_user, "user"=>{"email" => user.email, "authorizations_attributes"=>{"0"=>{"uid"=>"2846765163", "provider"=>"twitter"}}} }.to change(user.authorizations, :count).by(1)
      end
    end

    context 'user with email does not exist' do
      xit 'creates authorization' do
        expect { post :create_user, "user"=>{"email" => 'newuser@mail.ru', "authorizations_attributes"=>{"0"=>{"uid"=>"2846765163", "provider"=>"twitter"}}} }.to change(Authorization, :count).by(1)
      end
    end

    it 'creates authorization'
    it 'sends email'
  end

end