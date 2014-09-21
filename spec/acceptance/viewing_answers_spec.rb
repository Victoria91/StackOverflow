require 'rails_helper'

feature 'viewing answers', %q{
	Any user can view answers to a 
	selected question in order to
	know the solution
} do
	
	given(:question) { FactoryGirl.create(:question) }
	given(:answer) { FactoryGirl.create(:answer, question: question) }

	scenario 'view answer to a given question' do
		question.answers << answer
		visit question_path(question)
		expect(page).to have_content question.body
		save_and_open_page
		expect(page).to have_content answer.body
	end


end