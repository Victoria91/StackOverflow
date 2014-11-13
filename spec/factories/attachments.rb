# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
  end
end
