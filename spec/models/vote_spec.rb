require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :user }
  it { should belong_to :voteable }

  describe 'updating question rating after create' do
    let(:question) { create(:question) }

    it 'calls #vote_up on question after vote up' do
      expect(question).to receive(:vote_up)
      Vote.create(voteable: question, vote_type: '+1')
    end

    it 'calls #vote_down on question after vote down' do
      expect(question).to receive(:vote_down)
      Vote.create(voteable: question, vote_type: '-1')
    end
  end
end
