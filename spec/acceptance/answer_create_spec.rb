require 'rails_helper'

feature 'Answer question', %q(
  As a "User"
  I want to answer a question
  In order to help to solve a problem
) do

  given(:user) { FactoryGirl.create(:user) }
  given!(:question) { FactoryGirl.create(:question) }
  given(:answer) { FactoryGirl.build(:answer) }

  scenario 'a guest cannot answer' do
    visit question_path(question)
    expect(page).not_to have_button 'Create Answer'
    expect(page).not_to have_selector 'textarea'
  end

  scenario 'answer question with valid attributes', js: true do
    login_as user
    visit questions_path
    click_link question.title
    fill_in 'Your answer', with: answer.body
    click_on 'Create Answer'
    expect(current_path).to eq(question_path(question))
    expect(page).to have_content question.body
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'answer question with invalid attributes', js: true do
    login_as user
    visit questions_path
    click_link question.title
    click_on 'Create Answer'
    expect(page).to have_selector '.answer_errors'
    expect(current_path).to eq(question_path(question))
    expect(page).to have_content question.body
  end

end
