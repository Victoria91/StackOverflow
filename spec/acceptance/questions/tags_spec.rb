require 'rails_helper'

feature 'adding tags', %q(
  As a "User"
  I want to add tag to my question
  In order to link it with a category
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:tag) { create(:tag) }

  before { login_as user }

  scenario 'add tag to a new question' do
    visit new_question_path
    fill_in 'Title', with: 'new question title'
    fill_in 'Body', with: 'new question body'
    select tag.name, from: 'Tags'
    click_on 'Create Question'
    within '.tags' do
      expect(page).to have_content tag.name
    end
  end

  scenario 'add tag to an existed question', js: true do
    visit question_path(question)
    click_link 'Edit'
    fill_in 'Title', with: 'new question title'
    fill_in 'Body', with: 'new question body'
        #save_and_open_page
    #select_from_chosen(tag.name, from: 'Tags' )
    # fill_in 'Tags', with: tag.name
    #enable_element('question_tag_ids')
    select_from_chosen('question_tag_ids', tag.name)
    click_on 'Update Question'
    #save_and_open_page
    within '.tags' do
      expect(page).to have_content tag.name
    end
  end

  def select_from_chosen(selector, name)
    page.execute_script "jQuery('#{selector}').click();"
    page.execute_script "jQuery(\".chzn-results .active-result:contains('#{name}')\").click();"
  end
end