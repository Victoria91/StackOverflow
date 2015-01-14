require 'rails_helper'

RSpec.describe Question do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should ensure_length_of(:title).is_at_most(255) }
  it { should ensure_length_of(:title).is_at_least(10) }
  it { should ensure_length_of(:body).is_at_least(10) }
  it { should ensure_length_of(:body).is_at_most(1000) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:question_tags).dependent(:destroy) }
  it { should have_many(:tags).through(:question_tags) }
  it { should validate_uniqueness_of(:title).with_message('Looks like this question has already been asked! Try to search for it') }

  let(:question) { create(:question) }
  let!(:unaccepted_answer) { create(:answer, question: question) }
  let!(:accepted_answer) { create(:answer, question: question, accepted: true) }

  it_behaves_like 'Votable'

  describe '#tags_inclusion validation' do
    context 'when Tag.count < 5' do
      let!(:tags) { create_list(:tag, 3) }

      it 'is valid' do
        question = Question.new(attributes_for(:question))
        question.tags << tags
        expect(question).to be_valid
      end
    end

    context 'when Tag.count > 5' do
      let!(:tags) { create_list(:tag, 8) }

      it 'is invalid' do
        question = Question.new(attributes_for(:question))
        question.tags << tags
        question.save
        expect(question.errors[:tags]).to eq(['Omg! Can\'t beleive your answer responds to all tags at once! Some of them are redundant for sure :)'])
      end
    end
  end

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

  describe '.created_today' do
    let!(:yesterday_questions) { create_list(:question, 5, created_at: Time.now - 1.day) }
    let!(:today_questions) { create_list(:question, 5) }

    it 'contains today_questions' do
      questions = Question.created_today
      today_questions.each do |question|
        expect(questions).to include(question)
      end
    end

    it 'not contains yesterday questions' do
      questions = Question.created_today
      yesterday_questions.each do |question|
        expect(questions).not_to include(question)
      end
    end

  end

end
