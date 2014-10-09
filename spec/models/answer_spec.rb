require 'rails_helper'

RSpec.describe Answer, :type => :model do
  
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should validate_presence_of :question }
  it { should accept_nested_attributes_for :attachments }

  let!(:question) { FactoryGirl.create(:question) }
  let!(:answer_one) { FactoryGirl.create(:answer, question: question) }
  let!(:answer_two) { FactoryGirl.create(:answer, question: question) }

  it 'invalid_answer factory is invalid' do
  	expect(FactoryGirl.build(:invalid_answer)).not_to be_valid
  end

  describe '#toggle_accepted' do
    it 'changes accepted state to true for unaccepted' do
      expect{ answer_one.toggle_accepted }.to change(answer_one, :accepted).to true
    end

    it 'only one answer can be accepted' do
      answer_two.toggle_accepted
      answer_one.toggle_accepted
      expect(answer_one.question.answers.where(accepted: true).count).to eq(1)
    end

    it 'changes accept accepted state to false for accepted' do
      answer_one.toggle_accepted
      expect{ answer_one.toggle_accepted }.to change(answer_one.reload, :accepted).to false
    end
  end
end
