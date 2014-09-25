require 'rails_helper'

feature 'A guest cannot answer question', %q{
	As an authorized user 
	I want to answer a question
	In order to help to solve a problem
} do

	given(:user) { FactoryGirl.create(:user) }
	given(:question) { FactoryGirl.create(:question) }
	given(:answer) { FactoryGirl.build(:answer) }

	scenario 'a guest cannot answer' do
		visit question_path(question)
		expect(page).not_to have_link 'Answer'
	end

	scenario 'an authorized user can answer question' do
		login_as user
		visit question_path(question)
		click_link 'Answer'
		expect(page).to have_button 'Create Answer'
	end

	scenario 'answer question' do
		login_as user
		visit question_path(question)
		click_link 'Answer'
		fill_in 'Your answer', with: answer.body
		click_on 'Create Answer'
		expect(page).to have_content 'Your answer has been saved'
		expect(page).to have_content question.body
		expect(page).to have_content answer.body
	end

end

