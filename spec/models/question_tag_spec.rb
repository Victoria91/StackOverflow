require 'rails_helper'

RSpec.describe QuestionTag do
  it { should belong_to(:tag) }
  it { should belong_to(:question) }
end
