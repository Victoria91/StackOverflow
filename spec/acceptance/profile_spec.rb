require 'rails_helper'

feature 'profile page', %q(
  As a "User"
  I want to view my profile page
) do

  given(:user) { create(:user) }

  context 'authorized' do
    background do
      login_as user
      visit root_path
      click_link 'Profile'
    end     
    
    scenario 'can view common information' do
      expect(page).to have_content user.email
      expect(page).to have_content user.sign_in_count
      expect(page).to have_content user.created_at.strftime("%B %d, %Y, %A")
    end

    context 'authorizations' do
      scenario 'shows if they present' do
        user.authorizations << create(:authorization)
        visit profile_path
        expect(page).to have_content 'Authorizations'
        expect(page).to have_selector 'img'
      end

      scenario 'not shows if no authorizations' do
        expect(page).not_to have_content 'Authorizations'
      end
    end
  end

  scenario 'unauthorized cannot view profile page' do
    visit root_path
    expect(page).not_to have_link 'Profile'
  end

end
