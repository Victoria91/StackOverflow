shared_examples_for 'Votable' do
  let(:user) { create(:user) }
  let(:object) { create(described_class.to_s.underscore.to_sym) }
  
  describe '#vote_up(user)' do
    it 'increases object rating' do
      puts described_class
      expect { object.vote_up(user) }.to change { object.rating }.by(1)
    end

    it 'creates user\'s vote with positive type' do
      expect { object.vote_up(user) }.to change { user.votes.where(vote_type: '+1', voteable: object).count }.by(1)
    end
  end

  describe '#vote_down' do
    it 'decreases object rating' do
      expect { object.vote_down(user) }.to change { object.rating }.by(-1)
    end

    it 'creates user\'s vote with negative type' do
      expect { object.vote_down(user) }.to change { user.votes.where(vote_type: '-1', voteable: object).count }.by(1)
    end
  end
  
end