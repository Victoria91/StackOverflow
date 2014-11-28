require 'rails_helper'

RSpec.describe Answer do

  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :comments }
  it { should validate_presence_of :question }
  it { should accept_nested_attributes_for :attachments }

  let!(:question) { create(:question) }
  let!(:answer_one) { create(:answer, question: question) }
  let!(:answer_two) { create(:answer, question: question) }

  it 'invalid_answer factory is invalid' do
    expect(build(:invalid_answer)).not_to be_valid
  end

  describe '#toggle_accepted' do
    it 'changes accepted state to true for unaccepted' do
      expect { answer_one.toggle_accepted }.to change(answer_one, :accepted).to true
    end

    it 'only one answer can be accepted' do
      answer_two.toggle_accepted
      answer_one.toggle_accepted
      expect(answer_one.question.answers.where(accepted: true).count).to eq(1)
    end

    it 'changes accept accepted state to false for accepted' do
      answer_one.toggle_accepted
      expect { answer_one.toggle_accepted }.to change(answer_one.reload, :accepted).to false
    end
  end

  context 'new answer notifications' do
    let!(:subscriptions) { create_list(:subscription, 5, question: question, user: create(:user) ) }
    let(:unsubscribed_users) { create_list(:user, 5) }

    it 'notifies question author after create' do
      expect(AnswerNotifier).to receive(:author).and_call_original
      question.answers.create(attributes_for(:answer))
    end

    it 'notifies subscribed users' do
      subscriptions.each do |subscription|
        expect(AnswerNotifier).to receive(:subscribers).with(subscription.user, anything).and_call_original
      end
      question.answers.create(attributes_for(:answer))
    end

    it 'not notifies unsubscribed' do
      unsubscribed_users.each do |user|
        expect(AnswerNotifier).not_to receive(:subscribers)
      end
      question.answers.create(attributes_for(:answer))
    end
  end
end
