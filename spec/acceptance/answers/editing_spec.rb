require 'rails_helper'

feature 'editing_answer', %q(
  As an "Author of an answer"
  I want to edit it
  In order to fix it
) do

  given(:user) { FactoryGirl.create(:user) }
  given(:another_user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question) }
  given!(:answer) { FactoryGirl.create(:answer, user: user, question: question) }
  given!(:another_answer) { FactoryGirl.create(:answer, user: another_user, question: question) }

  context 'authorized' do
    before { login_as user }

    context 'edit own answer' do
      before do
        visit question_path(question)
        find('.editable_answer', text: answer.body).click
      end

      scenario 'editing own answer with valid attributes', js: true do
        within '.editable_answer_form' do
          expect(page).to have_selector 'textarea'
          fill_in 'answer[body]', with: 'new answer'
          click_on 'Update Answer'
        end
        within '.answers' do
          expect(page).to have_content 'new answer'
          expect(page).not_to have_selector 'textarea'
          expect(page).not_to have_content answer.body
        end
      end

      scenario 'editing own answer with invalid attributes', js: true do
        within '.editable_answer_form' do
          expect(page).to have_selector 'textarea'
          fill_in 'answer[body]', with: ''
          click_on 'Update Answer'
        end
        within '.answers' do
          expect(page).to have_selector 'textarea'
          expect(page).to have_selector '.answer_errors'
        end
      end

      scenario 'cancel edit', js: true do
        within '.editable_answer_form' do
          fill_in 'answer[body]', with: 'some strange text'
          click_button 'Cancel'
          expect(page).not_to have_selector 'textarea'
        end
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).not_to have_content 'some strange text'
        end
      end

    end

    scenario 'editing another answer' do
      visit question_path(question)
      expect(page).to have_content(answer.body)
      expect(page).to have_content(another_answer.body)
      within '.editable_answer' do
        expect(page).not_to have_content another_answer.body
      end
    end

  end

  scenario 'unauthorized user cannot edit answers' do
    visit question_path(question)
    expect(page).to have_content(answer.body)
    expect(page).to have_content(another_answer.body)
    expect(page).not_to have_selector '.editable_answer'
  end

end