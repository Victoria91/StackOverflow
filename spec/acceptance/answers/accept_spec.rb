require 'rails_helper'

feature 'accept answer', %q(
  As an "author of a question"
  I want to accept the most suitable answer
  In order to focus on its use
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }
  given(:answer) { create(:answer, question: question, user: another_user) }
  given(:accepted_answer) { create(:answer, question: question, accepted: true) }

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

      context 'after creating new answer #PrivatePub templates' do
        scenario 'accepting and reaccepting answer', js: true do
          visit question_path(question)
          create_answer
          expect(page).not_to have_selector '.accepted'
          find('.accept').click
          expect(page).to have_selector '.accepted'
          find('.accepted').click
          expect(page).not_to have_selector '.accepted'
        end

        def create_answer
          fill_in 'answer[body]', with: 'some strange text'
          click_on 'Create Answer'
        end
      end
    end
  end

  scenario 'on another question' do
    visit question_path(another_question)
    expect(page).not_to have_selector '.accept'
  end

  scenario 'unauthorized' do
    visit question_path(another_question)
    expect(page).not_to have_selector '.accept'
    visit question_path(question)
    expect(page).not_to have_selector '.accept'
  end

end
