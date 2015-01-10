# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "TagName#{n}"
  end

  factory :tag do
    name
  end
end
