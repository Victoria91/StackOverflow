require 'rails_helper'

feature 'delete answer', %q(
  As an "Owner of an answer"
  I want to delete question
) do

  given(:user) { FactoryGirl.create(:user) }
  given(:another_user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question, user: user) }
  given!(:answer) { FactoryGirl.create(:answer, question: question, user: user) }
  given!(:another_answer) { FactoryGirl.create(:answer, question: question, user: another_user) }

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
