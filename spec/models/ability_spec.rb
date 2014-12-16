require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'guest' do
    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }
  end

  context 'user' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }

    context 'Question' do
      it { should be_able_to(:create, Question) }
      let(:question) { create(:question, user: user) }
      let(:another_question) { create(:question, user: another_user) }

      context 'own question' do
        it { should be_able_to(:update, question) }
        it { should be_able_to(:destroy, question) }
      end

      context 'another question' do
        it { should_not be_able_to(:update, another_question) }
        it { should_not be_able_to(:destroy, another_question) }
      end

      context 'votes' do
        context 'on another_question' do

          context 'first time' do
            it { should be_able_to(:vote, another_question) }
          end

          context 'second time' do
            let!(:vote) { create(:vote, question: question, user: another_user) }

            it { should_not be_able_to(:vote, question) }
          end
        end

        context 'on own question' do
          it { should_not be_able_to(:vote, question) }
        end
      end

      context 'subscription' do
        let!(:own_question) { create(:question, user: user) }
        let(:question) { create(:question, user: another_user) }

        it { should be_able_to(:subscribe, question) }
        it { should_not be_able_to(:subscribe, own_question) }

        context 'second time' do
          let!(:subscription) { create(:subscription, question: question, user: user) }

          it { should_not be_able_to(:subscribe, question) }
        end

        context 'unsubscribe' do
          let!(:subscription) { create(:subscription, question: question, user: user) }

          it { should be_able_to(:unsubscribe, question) }
          it { should_not be_able_to(:unsubscribe, create(:question)) }
        end
      end

      context 'author notifications' do
        let(:question) { create(:question, user: user) }
        let(:another_question) { create(:question, user: create(:user)) }

        it { should be_able_to(:cancel_notifications, question) }
        it { should_not be_able_to(:cancel_notifications, another_question) }
      end
    end

    context 'Answer' do
      it { should be_able_to(:create, Answer) }
      let(:question) { create(:question, user: user) }
      let(:another_question) { create(:question, user: another_user) }
      let(:answer) { create(:answer, user: user, question: create(:question)) }
      let(:another_answer) { create(:answer, user: another_user, question: create(:question)) }

      context 'own answer' do
        it { should be_able_to(:update, answer) }
        it { should be_able_to(:destroy, answer) }
      end

      context 'another answer' do
        it { should_not be_able_to(:update, another_answer) }
        it { should_not be_able_to(:destroy, another_answer) }
      end

      context '#accept' do
        it { should be_able_to(:accept, create(:answer, question: question)) }
        it { should_not be_able_to(:accept, create(:answer, question: another_question)) }
      end
    end

    context 'Comment' do
      it { should be_able_to(:create, Comment) }
    end
  end

end
