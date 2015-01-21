require 'rails_helper'

feature 'profile page', %q(
  As a "User"
  I want to view my profile page
) do
  
  given(:user) { create(:user) }

  scenario 'authorized user can view profile page' do
    login_as user
    visit root_path
    click_link 'Profile'
    expect(page).to have_content user.email
  end

  scenario 'unauthorized cannot view profile page' do
    visit root_path
    expect(page).not_to have_link 'Profile'
  end

end