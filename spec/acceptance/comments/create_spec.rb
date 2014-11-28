require 'rails_helper'

feature 'create comment', %q(
  As a "User" 
  I want to create comment 
  In order to specify it
  ) do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  scenario 'unauthorized cannot create comment' do
    visit question_path(question)
    expect(page).not_to have_button 'Create Comment'
    expect(page).not_to have_button 'leave a comment'
  end

  context 'authorized' do
    background do
      login_as user
      visit question_path(question) 
    end
    
    scenario 'leave comment on question', js: true do
      fill_in 'Your comment:', with: 'my comment'
      click_on 'Create Comment'
      within '.comments' do
        expect(page).to have_content 'my comment'
      end
    end

    scenario 'leave comment on answer', js: true do
      find(".comment_answer_#{answer.id}").click
      fill_in 'Your comment:', with: 'my comment'
      click_on 'Create Comment'
      within ".answer_#{answer.id}_comments" do
        expect(page).to have_content 'my comment'
      end
    end
  end
    
end