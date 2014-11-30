require 'rails_helper'

feature 'delete answer', %q(
  As an "Owner of an answer"
  I want to delete question
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: another_user) }

  context 'authorized' do
    background do
      login_as user
      visit question_path(question)
    end

    scenario 'user can delete his answer', js: true do
      within '.answers' do
        find("#delete_answer_#{answer.id}_link").click
        expect(page).not_to have_content answer.body
      end
    end

    scenario 'delete own answer right after creating #PrivatePub templates', js: true do
      within '.answers' do # delete the previous answer
        find("#delete_answer_#{answer.id}_link").click
        expect(page).not_to have_content answer.body
      end
      fill_in 'answer[body]', with: 'some strange text'
      click_on 'Create Answer'
      within '.answers' do
        click_link 'Delete'
        expect(page).not_to have_content 'some strange text'
      end
    end

    scenario 'user cannot delete another answer', js: true do
      within '.answers' do
        expect(page).not_to have_selector "#delete_answer_#{another_answer.id}_link"
      end
    end
  end

  scenario 'unauthorized' do
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_selector "#delete_answer_#{another_answer.id}_link"
    end
  end

end
