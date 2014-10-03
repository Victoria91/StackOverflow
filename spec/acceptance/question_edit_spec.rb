require 'rails_helper'

feature 'edit question', %q{
	As an author of a question
	I want to edit my question
	In order to fix it
} do 

	given(:user) { FactoryGirl.create(:user) }
	given!(:question) { FactoryGirl.create(:question, user: user) }
	given(:another_user) { FactoryGirl.create(:user) }
	given!(:another_question) { FactoryGirl.create(:question, user: another_user) }

	context 'authorized' do
		before { login_as user }

		context 'edit own question' do
			before do 
				visit question_path(question)
				click_link 'Edit'
			end

			scenario 'edit my question vith valid attributes', js: true do
				fill_in "Title", with: 'New question title'
				fill_in "Body", with: 'New question body'
				click_on 'Update Question'
				within '.question' do
					expect(page).to have_content 'New question title'
					expect(page).to have_content 'New question body'
				end
				expect(page).not_to have_content question.body
				expect(page).not_to have_content question.title
				expect(page).not_to have_selector '.edit_question'
			end

			scenario 'edit my question with invalid attributes', js: true  do
				fill_in "Title", with: ''
				fill_in "Body", with: 'New question body'
				click_on 'Update Question'
				within 'h3' do
					expect(page).not_to have_content 'New question body'
				end
				within '.edit_question' do
					expect(page).to have_selector 'textarea'
				end
			end

			scenario 'cancel edit', js: true do
				fill_in "Title", with: 'New question title'
				click_on 'Cancel'
				within '.question' do
					expect(page).not_to have_content 'New question title'
				end
				expect(page).not_to have_selector '#edit_question_form'
			end
		end

		scenario 'edit someone elses question' do
			visit questions_path
			click_link another_question.title
			expect(page).not_to have_selector '.floatl'
			expect(page).not_to have_link 'Edit'
		end
	end

	scenario 'unauthorized is trying to edit' do
		visit questions_path
		click_link question.title
		expect(page).not_to have_selector '.floatl'
		expect(page).not_to have_link 'Edit'
	end

end