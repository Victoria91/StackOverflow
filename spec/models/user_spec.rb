require 'rails_helper'

RSpec.describe User do

  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :comments }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email, image: 'http://provider.com/picture' }) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email, image: 'http://provider.com/picture' }) }

        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.not_to change(User, :count)
        end

        it 'creates a new authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.provider).to eq(auth.provider)
        end

        it 'creates authorization with uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'creates authorization with user avatar' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.avatar_url).to eq(auth.info[:image])
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'newuser@mail.com', image: 'http://provider.com/picture' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth).email).to eq(auth.info[:email])
        end

        it 'creates authorization' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it 'creates authorization with uid' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations.first.uid).to eq(auth.uid)
        end

        it 'creates authorization with provider' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations.first.provider).to eq(auth.provider)
        end

        it 'creates authorization with user avatar' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations.first.avatar_url).to eq(auth.info[:image])
        end

      end

    end
  end

  describe '.send_daily_digest' do
    let!(:subscribed_users) { create_list(:user, 4) }
    let!(:unsubscribed_users) { create_list(:user, 4, digest: false) }

    context 'new questions exist' do
      let!(:questions) { create_list(:question, 5, user: users.last) }

      it 'sends digest to all subscribed users' do
        subscribed_users.each do |user|
          expect(DailyMailer).to receive(:digest).with(user).and_call_original 
        end
        User.send_daily_digest
      end

      it 'not sends digest to unsubscribed users' do
        unsubscribed_users.each do |user|
          expect(DailyMailer).not_to receive(:digest).with(user)
        end
        User.send_daily_digest
      end
    end

    context 'no new questions' do
      it 'not sends digest if there were no new questions' do
        expect(DailyMailer).not_to receive(:digest)
        User.send_daily_digest
      end
    end
  end

end
