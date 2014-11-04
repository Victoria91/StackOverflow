require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :user }
  it { should belong_to :question }
end
