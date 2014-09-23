require 'rails_helper'

feature 'A guest cannot answer question', %q{
	Only an authorized user can answer a question
} do

	given(:question) { FactoryGirl.create(:question) }
	given(:user) { FactoryGirl.create(:user) }

	scenario 'a guest cannot answer' do
		visit question_path(question)
		expect(page).not_to have_link 'Answer'
	end

	scenario 'an authorized user can answer question' do
		login_as user
		visit question_path(question)
		expect(page).to have_link 'Answer'
	end

end

