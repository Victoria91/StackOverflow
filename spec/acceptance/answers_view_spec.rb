require 'rails_helper'

feature 'viewing answers', %q(
  As an "Any user"
  I want to view answers to a
  selected question in order to
  know the solution
) do

  given!(:question) { FactoryGirl.create(:question) }
  given!(:answers) { FactoryGirl.create_list(:answer, 5, question: question) }
  given(:another_question) { FactoryGirl.create(:question) }
  given!(:other_answers) { FactoryGirl.create_list(:answer, 5, question: question) }

  scenario 'view answer to a given question' do
    visit question_path(question)
    expect(page).to have_content question.body
    answers.each { |a| expect(page).to have_content a.body }
  end

  scenario 'answers to another question are not shown' do
    visit question_path(another_question)
    other_answers.each { |a| expect(page).not_to have_content a.body }
  end

end
