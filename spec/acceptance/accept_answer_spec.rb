require 'rails_helper'

feature 'accept answer', %q{
	As an author of a question
	I want to accept the most suitable answer
	In order to focus on its use
} do

given(:user) { FactoryGirl.create(:user) }
given(:another_user) { FactoryGirl.create(:user) }
given(:question) { FactoryGirl.create(:question, user: user) }
given(:another_question) { FactoryGirl.create(:question, user: another_user) }
given(:answer) { FactoryGirl.create(:answer, question: question, user: another_user) }

context 'authorized' do
	before { login_as user }

	context 'own question' do
		before { visit question_path(:question) }

		scenario 'on own question' do
			visit question_path(:question)
			within '.answers .accepted' do
				expect(page).not_to have_selector '"#accept_answer_#{answer.id}"'
			end
			find("#accept_answer_#{answer.id}").click
			within '.answers .accepted' do
				expect(page).to have_selector '"#accept_answer_#{answer.id}"'
			end
		end

		scenario 'reaccept' do
			accepted_answer = FactoryGirl.create(:answer, question: question, accepted: true)
			expect(page).to have_selector '.accepted'
			find("#accept_answer_#{answer.id}").click
			within '.answers .accepted' do
				expect(page).to have_content answer.body
				expect(page).not_to have_content accepted_answer.body
			end
		end

		scenario 'cancel accept' do
			accepted_answer = FactoryGirl.create(:answer, question: question, accepted: true)
			within '.answers .accepted' do
				expect(page).to have_selector "#accept_answer_#{accepted_answer.id}"
			end
			find("#accept_answer_#{accepted_answer.id}").click
			within '.answers .accepted' do
				expect(page).not_to have_selector "#accept_answer_#{accepted_answer.id}"
			end
		end
	end

	scenario 'on another question' do
		visit question_path(another_question)
		expect(page).not_to have_selector '.accepted'
	end
end

scenario 'unauthorized' do
	visit question_path(another_question)
	expect(page).not_to have_selector '.accepted'	
	visit question_path(question)
	expect(page).not_to have_selector '.accepted'	
end


end