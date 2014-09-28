require 'rails_helper'

feature 'editing_answer', %q{
	As an author of an answer
	I want to edit it
	In order to fix it
} do 

	given(:user) { FactoryGirl.create(:user)}
	given(:question) { FactoryGirl.create(:question) }
	given(:answer) { FactoryGirl.create(:answer, user: user, question: question) }

	scenario 'editing my answer' do
		visit question_path(question)
		click_on answer.body
		fill_in 'Edit Answer', with: 'new answer'
		click_on 'Edit'
		expect(page).to have_link 'new answer'
	end
end