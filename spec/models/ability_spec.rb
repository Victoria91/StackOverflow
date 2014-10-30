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

      context 'own question' do
        it { should be_able_to(:update, create(:question, user: user), user: user) }
        it { should be_able_to(:destroy, create(:question, user: user), user: user) }
      end

      context 'another question' do
        it { should_not be_able_to(:update, create(:question, user: another_user), user: user) }
        it { should_not be_able_to(:destroy, create(:question, user: another_user), user: user) }
      end
    end

    context 'Answer' do
      it { should be_able_to(:create, Answer) }

      context 'own question' do
        it { should be_able_to(:update, create(:answer, user: user, question: create(:question)), user) }
        it { should be_able_to(:destroy, create(:answer, user: user, question: create(:question)), user) }
      end

      context 'another question' do
        it { should_not be_able_to(:update, create(:answer, user: another_user, question: create(:question)), user: user) }
        it { should_not be_able_to(:destroy, create(:answer, user: another_user, question: create(:question)), user: user) }
      end

      context '#accept' do
        it { should_not be_able_to(:accept, create(:answer, question: create(:question, user: user)), user: user)}
      end
    end
  end

end
