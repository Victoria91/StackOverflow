require 'rails_helper'

feature 'accept answer', %q(
  As an "author of a question"
  I want to accept the most suitable answer
  In order to focus on its use
) do

  given(:user) { FactoryGirl.create(:user) }
  given(:another_user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question, user: user) }
  given(:another_question) { FactoryGirl.create(:question, user: another_user) }
  given(:answer) { FactoryGirl.create(:answer, question: question, user: another_user) }
  given(:accepted_answer) { FactoryGirl.create(:answer, question: question, accepted: true) }

  context 'authorized' do
    before { login_as user }

    context 'own question' do
      scenario 'accept answer', js: true do
        answer
        visit question_path(question)
        expect(page).not_to have_selector '.accepted'
        find("#accept_answer_#{answer.id}").click
        expect(page).to have_selector '.accepted'
      end

      scenario 'reaccept', js: true do
        accepted_answer
        visit question_path(question)
        expect(page).to have_selector '.accepted'
        find('.accepted').click
        expect(page).not_to have_selector '.accepted'
      end
    end

    scenario 'on another question' do
      visit question_path(another_question)
      expect(page).not_to have_selector '.accept'
    end
  end

  scenario 'unauthorized' do
    visit question_path(another_question)
    expect(page).not_to have_selector '.accept'
    visit question_path(question)
    expect(page).not_to have_selector '.accept'
  end

end
