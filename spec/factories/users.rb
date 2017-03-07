require 'faker'

FactoryGirl.define do
  factory :role do
    name Faker::Lorem.word
  end

  factory :user do
    name Faker::Name.name
    sequence(:email){ |n| "user#{n}@factory.com" }
    password "verysecure"
    trait :student do
      after(:create) do |user|
        user.roles << create(:role, name: "Student")
      end
    end
  end
end
