require 'faker'

FactoryGirl.define do
  factory :quiz do
    sequence(:title) { |n| "question#{n}" }
    user
  end
end
