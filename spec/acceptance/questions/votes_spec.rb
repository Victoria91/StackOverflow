require 'rails_helper'

feature 'vote for a question', %q(
  As a "User"
  I want to vote for a question
  In order to mark its usefull
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, rating: 10) }
  given(:own_question)  { create(:question, user: user) }

  context 'unauthorized' do
    background do
      visit questions_path
      click_on question.title
    end

    scenario 'the raiting of question is shown' do
      expect(page).to have_content question.rating
    end

    scenario 'unauthorized cannot vote' do
      expect(page).not_to have_selector '.vote_up_link'
      expect(page).not_to have_selector '.vote_down_link'
    end
  end

  context 'authorized' do
    background do
      login_as user 
      visit question_path(question)
    end

    scenario 'author cannot vote' do
      visit question_path(own_question)
      expect(page).not_to have_selector '.vote_up_link'
      expect(page).not_to have_selector '.vote_down_link'
    end

    scenario 'vote up', js: true do
      expect(page).to have_content question.rating
      find('.vote_up_link').click
      expect(page).to have_content(question.rating + 1)
    end

    scenario 'vote down', js: true do
      expect(page).to have_content question.rating
      find('.vote_down_link').click
      expect(page).to have_content(question.rating - 1)
    end

    scenario 'cannot vote up twice', js: true do
      find('.vote_up_link').click
      expect(page).to have_selector '.vote_up_link'
    end

    scenario 'cannot vote down twice', js: true do
      find('.vote_down_link').click
      expect(page).to have_selector '.vote_down_link'
    end
  end

end