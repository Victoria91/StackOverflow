require 'rails_helper'

feature 'vote for an answer', %q(
  As a "User"
  I want to vote for an answer
  In order to mark it's significance
) do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:another_answer) { create(:answer, question: question) }
  given!(:own_answer) { create(:answer, question: question, user: user) }

  context 'authorized' do
    scenario 'cannot vote' do
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).not_to have_selector ".vote_up_link"
        expect(page).not_to have_selector ".vote_down_link"
      end
    end
  end

  context 'anauthorized' do
    background do
      login_as user
      visit question_path(question)
    end

    scenario 'cannot vote for own question' do
      within "#answer_#{own_answer.id}" do
        expect(page).not_to have_selector ".vote_up_link"
        expect(page).not_to have_selector ".vote_down_link"
      end
    end

    scenario 'vote up for another question', js: true do
      within "#answer_#{another_answer.id}" do
        expect(page).to have_content answer.rating
        find('.vote_up_link').click
        expect(page).to have_content answer.rating + 1
      end
    end

    scenario 'vote down for another question', js: true do
      within "#answer_#{another_answer.id}" do
        expect(page).to have_content answer.rating
        find('.vote_down_link').click
        expect(page).to have_content answer.rating - 1
      end
    end

    scenario 'cannot vote up twice', js: true do
      within "#answer_#{another_answer.id}" do
        find('.vote_up_link').click
        expect(page).not_to have_selector '.vote_up_link'
      end
    end
    
    scenario 'cannot vote down twice', js: true do
      within "#answer_#{another_answer.id}" do
        find('.vote_down_link').click
        expect(page).not_to have_selector '.vote_down_link'
      end
    end

  end

end