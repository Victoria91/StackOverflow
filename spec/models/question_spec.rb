require 'rails_helper'

RSpec.describe Question do

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :answers }
  it { should have_many :attachments }
  it { should ensure_length_of(:title).is_at_most(255) }
  it { should accept_nested_attributes_for :attachments }

  let(:question) { FactoryGirl.create(:question) }
  let!(:unaccepted_answer) { FactoryGirl.create(:answer, question: question) }
  let!(:accepted_answer) { FactoryGirl.create(:answer, question: question, accepted: true) }

  describe '#accepted_answer' do
    it 'returns an accepted_answer' do
      answer = question.accepted_answer
      expect(answer).not_to eq(unaccepted_answer)
      expect(answer).to eq(accepted_answer)
    end

    it 'returns nil when there is no accepted answer' do
      accepted_answer.update!(accepted: false)
      expect(question.accepted_answer).to eq(nil)
    end

  end
 
  describe '#vote_up' do
    it 'increases question rating' do
      expect{question.vote_up}.to change(question.rating).by(1)
    end
  end

  describe '#vote_down' do
    it 'decreases question rating' do
      expect{question.vote_down}.to change(question.rating).by(1)
    end

  end

end
