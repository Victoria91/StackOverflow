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
    select_from_chosen(tag.name, from: 'question_tag_ids')
    click_on 'Update Question'
    within '.tags' do
      expect(page).to have_content tag.name
    end
  end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script('value')
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('chosen:updated')")
  end

end
