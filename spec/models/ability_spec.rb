require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'guest' do
    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }
  end

  context 'user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }

    it { should be_able_to(:read, :all) }
    it { should_not be_able_to(:manage, :all) }

    context 'Question' do
      it { should be_able_to(:create, Question) }

      context 'own question' do
        let(:question)  { FactoryGirl.create(:question, user: user) }

        it { should be_able_to(:update, :question) }
        it { should be_able_to(:delete, :question) }
      end

      context 'another question' do
        let(:question) { FactoryGirl.create(:question, user: another_user) }

        it { should_not be_able_to(:update, :question) }
        it { should_not be_able_to(:delete, :question) }
      end
    end

    context 'Answer' do
      it { should be_able_to(:create, Answer) }

      context 'own question' do
        let(:answer)  { FactoryGirl.create(:answer, user: user) }

        it { should be_able_to(:update, :answer) }
        it { should be_able_to(:delete, :answer) }
      end

      context 'another question' do
        let(:answer) { FactoryGirl.create(:answer, user: another_user) }

        it { should_not be_able_to(:update, :answer) }
        it { should_not be_able_to(:delete, :answer) }
      end
    end
  end

end
