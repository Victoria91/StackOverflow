require 'rails_helper'

feature 'delete question', %q{
	As an authorized user I want to
	delete question that was asked by me
} do

	given(:user) { FactoryGirl.create(:user) }
	given(:another_user) { FactoryGirl.create(:user) }
	given(:his_question) { FactoryGirl.create(:question, user: user) }
	given(:another_question) { FactoryGirl.create(:question, user: another_user) }


	before { login_as user }

	scenario 'can delete his question' do
		visit question_path(his_question)
		expect(page).to have_link 'Delete'
	end

	scenario 'cannot delete another question' do
		visit question_path(another_question)
		expect(page).not_to have_link 'Delete'
	end
end