# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end

  factory :invalid_question, class: Question do
    title { Faker::Lorem.sentence }
  end
end
