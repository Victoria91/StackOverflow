require 'rails_helper'

RSpec.describe Question, :type => :model do
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :answers }
  it { should ensure_length_of(:title).is_at_most(255) }

  let!(:question) { FactoryGirl.create(:question) }
  let!(:answer_one) { FactoryGirl.create(:answer, question: question) }
  let!(:answer_two) { FactoryGirl.create(:answer, question: question) }

  it '#toggle_accepted changes accepted state to true for unaccepted' do
  	expect{ question.toggle_accepted(answer_one) }.to change(answer_one, :accepted).to true
  end

  it 'only one answer can be accepted' do
    question.toggle_accepted(answer_two)
  	question.toggle_accepted(answer_one) 
    expect(question.answers.where(accepted: true).count).to eq(1)
  end

  it '#toggle_accepted changes accept accepted state to false for accepted' do
    question.toggle_accepted(answer_one)
    expect{ question.toggle_accepted(answer_one) }.to change(answer_one.reload, :accepted).to false
  end
end
