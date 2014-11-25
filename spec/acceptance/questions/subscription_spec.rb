require 'rails_helper'

feature 'subscribe to a question', %q(
  As a "User"
  I want to subscribe to a question
  in order to receive letters about new answers
) do

  given(:user) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:question) { create(:question, user: create(:user)) }

  context 'unauthorized' do
    scenario 'cannot subscribe' do
      visit question_path(question)
      expect(page).not_to have_link 'Subscribe'
      expect(page).not_to have_link 'Unsubscribe'
    end
  end

  context 'authorized', js: true do
    background { login_as user }

    scenario 'cannot subscribe to own question' do
      visit question_path(own_question)
      expect(page).not_to have_link 'Subscribe'
    end

    scenario 'can subscribe to another question' do
      visit question_path(question)
      click_link 'Subscribe'
      expect(page).to have_content "You have been successfully subscribed to the question's updates"
      expect(page).not_to have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
    
    scenario 'cannot subscribe twice' do
      create(:subscription, user: user, question: question)
      visit question_path(question)
      expect(page).not_to have_link 'Subscribe'
    end

    scenario 'unsubscribe' do
      create(:subscription, user: user, question: question)
      visit question_path(question)
      click_link 'Unsubscribe'
      expect(page).to have_content("You have been successfully unsubscribed")
    end
  end
end