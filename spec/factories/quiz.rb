require 'faker'

FactoryGirl.define do
  factory :quiz do
    sequence(:title) { |n| "question#{n}" }
    attempts 1
    release_date Date.today
    user
  end
end
