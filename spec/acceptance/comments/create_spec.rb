require 'rails_helper'

feature 'create comment', %q(
  As a "User" 
  I want to create comment 
  In order to specify it
  ) do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'unauthorized cannot create question' do
    visit question_path(question)
    expect(page).not_to have_button 'Create Comment'
  end

  scenario 'authorized can create question', js: true do
    login_as user
    visit question_path(question)
    fill_in 'Your comment:', with: 'my comment'
    click_on 'Create Comment'
    within '.comments' do
      expect(page).to have_content 'my comment'
    end
  end
    
end