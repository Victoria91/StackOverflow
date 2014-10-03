require 'rails_helper'

RSpec.describe Question, :type => :model do
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :answers }
  it { should ensure_length_of(:title).is_at_most(255) }

  let(:question) { FactoryGirl.create(:question) }
  let(:answer_one) { FactoryGirl.create(:answer, question: question) }
  let(:answer_two) { FactoryGirl.create(:answer, question: question) }

  it '#accept changes accepted state' do
  	expect{ question.toggle_accept(answer_one) }.to change(answer_one, :accepted).to true
  end

  it 'only one answer can be accepted' do
  	question.toggle_accept(answer_two)
  	expect{ question.toggle_accept(answer_one) }.to change(question.answer_two, :accepted).to false
  end

  it 'reaccepts changes accept state' do
  end
end
