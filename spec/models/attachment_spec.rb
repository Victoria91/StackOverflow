require 'rails_helper'

RSpec.describe Attachment do
  it { should belong_to(:attachmentable) }
end
