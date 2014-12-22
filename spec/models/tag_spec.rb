require 'rails_helper'

RSpec.describe Tag do
  it { should have_many(:questions).through(:question_tags) }
  it { should have_many(:question_tags) }
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
end
