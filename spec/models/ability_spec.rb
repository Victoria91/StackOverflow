require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'guest' do
    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }
  end

  context 'user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }

    context 'Question' do
      it { should be_able_to(:create, Question) }
      let(:question) { create(:question, user: user) }
      let(:another_question) { create(:question, user: another_user) }

      context 'own question' do
        it { should be_able_to(:update, question, user: user) }
        it { should be_able_to(:destroy, question, user: user) }
      end

      context 'another question' do
        it { should_not be_able_to(:update, another_question, user: user) }
        it { should_not be_able_to(:destroy, another_question, user: user) }
      end

      context 'votes' do
        context 'on another_question' do
          context 'first time' do
            it { should be_able_to(:vote, question, user: another_user) }
          end

          context 'second time' do
            let!(:vote) { create(:vote, question: question, user: another_user) }

            it { should_not be_able_to(:vote, question, user: another_user) }            
          end
        end

        context 'on own question' do
          it { should_not be_able_to(:vote, question, user: user) }
        end
      end
    end

    context 'Answer' do
      it { should be_able_to(:create, Answer) }
      let(:answer) { create(:answer, user: user, question: create(:question)) }
      let(:another_answer) { create(:answer, user: another_user, question: create(:question)) }

      context 'own question' do
        it { should be_able_to(:update, answer, user) }
        it { should be_able_to(:destroy, answer, user) }
      end

      context 'another question' do
        it { should_not be_able_to(:update, another_answer, user: user) }
        it { should_not be_able_to(:destroy, another_answer, user: user) }
      end

      context '#accept' do
        it { should_not be_able_to(:accept, create(:answer, question: create(:question, user: another_user)), user: user) }
        it { should be_able_to(:accept, create(:answer, question: create(:question, user: user)), user: user) }
      end
    end
  end

end
