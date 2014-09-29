require 'rails_helper'

feature 'edit question', %q{
	As an author of a question
	I want to edit my question
	In order to fix it
} do 

	given(:user) { FactoryGirl.create(:user) }
	given(:question) { FactoryGirl.create(:question, user: user) }
	given(:another_user) { FactoryGirl.create(:user) }

	context 'authorized' do
		before { login_as user }

		scenario 'edit my question vith valid attributes' do
			visit questions_path
			click_link question.title
			find('.editable_question', text: question.body).click_link
			fill_in "question[title]", with: 'New question title'
			fill_in "question[body]", with: 'New question body'
			click_on 'Update Question'
			expect(page).not_to have_content question.body
			expect(page).not_to have_content question.title
		end

		scenario 'edit my question with invalid attributes' do
			visit questions_path
			click_link question.title
			find('.editable_question', text: question.body).click_link
			fill_in "question[title]", with: ''
			fill_in "question[body]", with: 'New question body'
			click_on 'Update Question'
			expect(page).to have_selector 'textarea'
		end

		scenario 'edit someone elses question' do
			visit questions_path
			click_link question.title
			expect(page).not_to have_selector '.editable_question'
		end
	end

	scenario 'unauthorized is trying to edit' do
		visit questions_path
		click_link question.title
		expect(page).not_to have_selector '.editable_question'
	end

end