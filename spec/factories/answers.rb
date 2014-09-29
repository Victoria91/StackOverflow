# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
  end

  factory :invalid_answer, class: Answer do
  end
end
