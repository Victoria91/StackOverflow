require 'rails_helper'

feature 'delete question', %q{
	As an authorized user I want to
	delete question that was asked by me
} do

	given(:user) { FactoryGirl.create(:user) }
	given(:another_user) { FactoryGirl.create(:user) }
	given!(:his_question) { FactoryGirl.create(:question, user: user) }
	given!(:another_question) { FactoryGirl.create(:question, user: another_user) }

	before { login_as user }

	scenario 'can delete his question' do
		visit questions_path
		expect(page).to have_link his_question.title
		expect(page).to have_link another_question.title
		visit question_path(his_question)
		click_link 'Delete'
		expect(page).to have_content 'Your question has been deleted'
		expect(page).not_to have_link his_question.title
	end

	scenario 'cannot delete another question' do
		visit question_path(another_question)
		expect(page).not_to have_link 'Delete'
	end
end