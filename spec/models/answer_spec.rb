require 'rails_helper'

RSpec.describe Answer, :type => :model do
  
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should validate_presence_of :question }
 
  it 'invalid_answer factory is invalid' do
  	expect(FactoryGirl.build(:invalid_answer)).not_to be_valid
  end
end
