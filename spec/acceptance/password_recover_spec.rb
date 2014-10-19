require 'rails_helper'

feature 'recover password', %q(
  As a "Guest"
  I want to recover my password
  To recover my access to the whole functional
) do

  given(:user) { FactoryGirl.create(:user) }

  background do
    clear_emails
  end

  scenario 'request password recover instructions' do
    visit root_path
    click_link 'Sign in'
    click_link 'Forgot your password?'
    expect(page).to have_content(/email/i)
    fill_in 'Email', with: user.email
    click_on 'Send me reset password instructions'
    expect(page).to have_content 'You will receive an email with instructions'
    open_email(user.email)
    expect(current_email).to have_content('Someone has requested a link to change your password.')
    current_email.click_link 'Change my password'
    fill_in 'New password', with: 'newpassword2'
    fill_in 'Confirm your new password', with: 'newpassword2'
    click_link 'Exit'
    click_link 'Sign in'
    user.reload
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
  # fill_in 'Password', with: 'newpassword2'
  # save_and_open_page
    click_on 'Sign in'
    expect(page).to have_content(/success/i)
  end

end
