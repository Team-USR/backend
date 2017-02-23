require 'faker'

FactoryGirl.define do
  factory :role do
    name Faker::Lorem.word
  end

  factory :user do
    name Faker::Name.name
    email Faker::Internet.unique.email
    password Faker::Lorem.word
    trait :student do
      after(:create) do |user|
        user.roles << create(:role, name: "Student")
      end
    end
  end

  factory :group do
    name Faker::Name.name
  end
end
