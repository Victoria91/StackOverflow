require 'rails_helper'

RSpec.describe Comment do
  it { should validate_presence_of :body }
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
end
