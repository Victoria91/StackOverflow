require 'rails_helper'

feature 'attach file to question', %q(
  As an "Author of a question
  I want to be attach file to my question
  In order to illustrate it
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    login_as user
  end

  scenario 'attach to a new question' do
    visit new_question_path
    fill_in 'Title', with: "New #{question.title}"
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Question'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'attach to an existed question', js: true do
    visit question_path(question)
    click_link 'Edit'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Update Question'
    expect(page).to have_link 'spec_helper.rb'
  end
end
