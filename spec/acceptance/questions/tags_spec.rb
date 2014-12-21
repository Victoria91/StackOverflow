require 'rails_helper'

feature 'adding tags', %q(
  As an "User"
  I want to add tag to my question
  In order to link it with a category
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before { login_as user }

  scenario 'add tag to a new question' do
    visit new_question_path
    fill_in 'Title', with: 'new question title'
    fill_in 'Body', with: 'new question body'
    select 'ruby', from: 'tags'
    click_on 'Create Question'
  end

  scenario 'add tag to an existed question' do
    visit question_path(question)
    click_link 'Edit'
    fill_in 'Title', with: 'new question title'
    fill_in 'Body', with: 'new question body'
    select 'ruby', from: 'tags'
    click_on 'Update Question'
  end
end