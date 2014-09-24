require 'rails_helper'

feature 'reqistration', %q{
	As a guest
	I want to register in a system
	to get an access to the whole functional
} do
	
	scenario 'reqistration' do
		visit root_path
		click_link 'Sign up'
		fill_in 'Email', with: 'test@mail.ru'
		fill_in 'user[password]', with: '1qwerty2'
		fill_in 'user[password_confirmation]', with: '1qwerty2'
		click_on 'Sign up'
		expect(page).to have_content "Welcome! You have signed up successfully."
	end

end