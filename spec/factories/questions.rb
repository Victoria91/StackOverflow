# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    rating { Faker::Number.digit }
    user { create(:user) }
  end

  factory :invalid_question, class: Question do
    title { Faker::Lorem.sentence }
  end
end
