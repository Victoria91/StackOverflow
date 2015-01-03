shared_examples_for 'Provider returning email' do
  let(:user) { create(:user) }

  it 'logins user with provider data' do
    allow(User).to receive(:find_for_oauth).with(stub_env_for_omniauth) { user }
    get provider
    expect(controller.current_user).to eq(user)
  end
end
