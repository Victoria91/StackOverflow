require 'rails_helper'

feature 'sign in with social network', %q(
  As a "Quest"
  I want to sign in with facebook
) do

  background do 
    visit root_path
    click_link 'Sign in'
    mock_auth_hash
  end

  context 'sign in with' do
    scenario 'sign in with facebook' do
      click_on 'Facebook'
      expect(page).to have_content('Successfully authenticated from Facebook account.')
      expect(page).to have_link 'Ask your question'
      expect(page).to have_selector('img')
    end

    scenario 'sign in with vkontakte' do
      click_on 'Vkontakte'
      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
      expect(page).to have_link 'Ask your question'
      expect(page).to have_selector('img')
    end

    scenario 'sign in with twitter' do
      click_on 'Twitter'
      fill_in 'Email', with: 'mail@mail.com'
      click_button 'Send confirmation instructions'
      open_email('mail@mail.com')
      expect(current_email).to have_link 'Confirm my account'
    end
  end

end
