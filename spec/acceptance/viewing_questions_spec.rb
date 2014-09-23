require 'rails_helper'

feature 'view questions', %q{
	As any user
	I want to be able to view questions
	to find the similar problem that I have
} do
	
	given(:questions) { FactoryGirl.create_list(:question, 5) }

	scenario 'view questions' do
		questions
		visit questions_path
		#save_and_open_page
		questions.each do |q|
			expect(page).to have_link q.title
		end
	end

end