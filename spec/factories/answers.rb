# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    user { create(:user) }
  end

  factory :invalid_answer, class: Answer do
    body ''
  end
end
