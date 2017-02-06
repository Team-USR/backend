require 'faker'

FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.unique.email
    password Faker::Lorem.word
  end
end
