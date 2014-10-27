require 'rails_helper'

feature 'sign in with social network', %q(
  As a "Quest"
  I want to sign in with facebook
) do

  it 'sign in with facebook' do
    visit root_path
    click_link 'Sign in'
    mock_auth_hash
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from Facebook account.')
  end

  it 'sign in with vkontakte' do
    visit root_path
    click_link 'Sign in'
    mock_auth_hash
    click_link 'Sign in with Vkontakte'
    expect(page).to have_content('Successfully authenticated from Vkontakte account.')
  end

end
