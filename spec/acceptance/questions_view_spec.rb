require 'rails_helper'

feature 'view questions', %q(
  As "Any user"
  I want to be able to view questions
  to find the similar problem that I have
) do

  given!(:questions) { FactoryGirl.create_list(:question, 5) }

  scenario 'view questions' do
    visit questions_path
    questions.each { |q| expect(page).to have_link q.title }
  end

end
