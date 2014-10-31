require 'rails_helper'

feature 'vote for a question', %q(
  As a "User"
  I want to vote for a question
  In order to mark its usefull
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, raiting: 10) }

  context 'unauthorized' do
    background do
      visit questions_path
      click_on question.title
    end

    scenario 'the raiting of question is shown' do
      expect(page).to have_content question.raiting
    end

    scenario 'unauthorized cannot vote' do
      expect(page).not_to have_selector '.vote_up'
      expect(page).not_to have_selector '.vote_down'
    end
  end

  context 'authorized' do
    background do
      login_as user 
      visit question_path(question)
    end

    scenario 'author cannot vote' do
      expect(page).not_to have_selector '.vote_up'
      expect(page).not_to have_selector '.vote_down'
    end

    scenario 'vote up' do
      expect(page).to have_content question.raiting
      click_on '.vote_up'
      expect(page).to have_content(question.raiting + 1)
    end

    scenario 'vote down' do
      expect(page).to have_content question.raiting
      click_on '.vote_down'
      expect(page).to have_content(question.raiting - 1)
    end

    scenario 'cannot vote up twice' do
      click_on '.vote_up'
      expect(page).to have_selector '.vote_up'
    end

    scenario 'cannot vote down twice' do
      click_on '.vote_down'
      expect(page).to have_selector '.vote_down'
    end
  end

end