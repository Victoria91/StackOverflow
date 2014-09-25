require 'rails_helper'

feature 'recover password', %q{
	As a guest
	I want to recover my password 
	To recover my access to the whole functional
} do

	given(:user) { FactoryGirl.create(:user) }

	scenario 'request password recover instructions' do
		visit root_path
		click_link 'Sign in'
		click_link 'Forgot your password?'
		expect(page).to have_content (/email/i)
		fill_in 'Email', with: user.email
		click_on 'Send me reset password instructions'
		expect(page).to have_content 'You will receive an email with instructions on how to reset your password in a few minutes.'
	end
	
end