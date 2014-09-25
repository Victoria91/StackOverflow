require 'rails_helper'

feature 'ask question', %q{
	As an authorized user 
	I want to be able to ask question
	In order to solve my problem 
} do
	
	given(:user) { FactoryGirl.create(:user) }
	given(:question) { FactoryGirl.build(:question) }

	scenario 'a guest cannot ask question' do
		visit root_path
		expect(page).not_to have_link 'Ask your question'
	end

	scenario 'authorized user can ask question' do
		login_as user
		visit root_path
		click_link 'Ask your question'
		expect(page).to have_button 'Create Question'
	end

	scenario 'asking question' do 
		login_as user
		visit root_path
		click_link 'Ask your question'
		fill_in 'Title', with: question.title
		fill_in 'Body', with: question.body
		click_on 'Create Question'
		expect(page).to have_content 'Your question has been saved.'
		expect(page).to have_content question.title
		expect(page).to have_content question.body
	end

end