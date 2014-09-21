require 'rails_helper'

feature 'A guest cannot ask question', %q{
	Only authorized user can ask question
} do
	
	given(:user) { FactoryGirl.create(:user) }

	scenario 'a guest cannot ask question' do
		visit root_path
		expect(page).not_to have_link 'Ask your question'
	end

	scenario 'an authorized user can ask question' do
		login_as user
		visit root_path
		expect(page).to have_link 'Ask your question'
	end

end