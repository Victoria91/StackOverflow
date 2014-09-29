require 'rails_helper'

feature 'editing_answer', %q{
	As an author of an answer
	I want to edit it
	In order to fix it
} do 

	given(:user) { FactoryGirl.create(:user)}
	given(:question) { FactoryGirl.create(:question) }
	given!(:answer) { FactoryGirl.create(:answer, user: user, question: question) }

	scenario 'editing my answer', js: true do
		login_as user
		visit question_path(question)
		find('.editable_answer', :text => answer.body).click 
		within '.editable_answer_form' do
			fill_in 'answer[body]', with: 'new answer'
			click_on 'Update Answer'
		end
		within '.answers' do
			expect(page).to have_content 'new answer'
			expect(page).not_to have_selector 'textarea'
			expect(page).not_to have_content answer.body
		end
	end
end